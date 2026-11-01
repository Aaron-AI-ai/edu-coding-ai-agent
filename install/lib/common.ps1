# check · download · install · claude-setup 이 함께 쓰는 함수 (Windows PowerShell 5.1 이상)

# 네이티브 명령(java -version 등)이 stderr 로 쓰는 출력을 오류로 멈추지 않도록 Continue · 꼭 잡을 곳만 -ErrorAction Stop
$ErrorActionPreference = 'Continue'
$ProgressPreference = 'SilentlyContinue'   # 5.1 의 진행 막대는 큰 파일 다운로드를 매우 느리게 한다
[Console]::OutputEncoding = [Text.Encoding]::UTF8
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$InstallRoot = Split-Path -Parent $PSScriptRoot   # 이 파일은 install\lib 에 있다
$RepoRoot    = Split-Path -Parent $InstallRoot
$PackageDir  = Join-Path $InstallRoot 'packages'
$Config      = Import-PowerShellDataFile (Join-Path $InstallRoot 'tools.psd1')

# 끝낼 때 — 이 스크립트를 실행하려고 새로 띄운 창(탐색기 「PowerShell에서 실행」 · .bat)이면 엔터를 칠 때까지 기다린다
# 이미 열어 둔 터미널에서 .\check.ps1 로 실행했다면 프로세스 인자에 스크립트 경로가 없으므로 기다리지 않는다
function Exit-Script([int]$Code = 0) {
    $script = $MyInvocation.PSCommandPath
    $launched = $false
    if ($script) { $launched = [bool]([Environment]::GetCommandLineArgs() | Where-Object { $_ -like "*$(Split-Path $script -Leaf)*" }) }
    if ($launched -and -not $env:EDU_INSTALL_NOPAUSE) {
        Write-Host ''
        [void](Read-Host '엔터를 누르면 창이 닫힙니다')
    }
    exit $Code
}

function Write-Title([string]$Text) {
    Write-Host ''
    Write-Host "=== $Text ===" -ForegroundColor Cyan
}

function Write-State([string]$State, [string]$Text) {
    $color = @{ OK = 'Green'; MISSING = 'Yellow'; OLD = 'Yellow'; WARN = 'Yellow'; FAIL = 'Red'; INFO = 'Gray' }[$State]
    if (-not $color) { $color = 'White' }
    Write-Host ('  [{0,-7}] ' -f $State) -ForegroundColor $color -NoNewline
    Write-Host $Text
}

# 설치 직후에도 새 터미널 없이 명령을 찾도록 PATH 를 레지스트리에서 다시 읽는다
function Update-SessionPath {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user    = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = (@($machine, $user) | Where-Object { $_ }) -join ';'
}

function Add-UserPath([string]$Dir) {
    if (-not (Test-Path $Dir)) { return }
    $u = [Environment]::GetEnvironmentVariable('Path', 'User')
    if (($u -split ';') -notcontains $Dir) { [Environment]::SetEnvironmentVariable('Path', ((@($u, $Dir) | Where-Object { $_ }) -join ';'), 'User') }
    if (($env:Path -split ';') -notcontains $Dir) { $env:Path += ";$Dir" }
}

function Test-Winget { [bool](Get-Command winget -ErrorAction SilentlyContinue) }

function Test-WingetPackage([string]$Id) {
    if (-not $Id -or -not (Test-Winget)) { return $false }
    $out = winget list --id $Id -e --accept-source-agreements 2>$null | Out-String
    return ($out -match [regex]::Escape($Id))
}

# 명령의 버전 문자열 · 없으면 $null · 있지만 버전을 못 읽으면 ''
function Get-CmdVersion([string]$Cmd, [string[]]$ArgList, [string]$Regex) {
    $c = Get-Command $Cmd -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $c) { return $null }
    # Microsoft Store 의 python 바로가기(설치 안내 창만 띄움)는 설치로 보지 않는다
    if ($c.Source -like '*\WindowsApps\*') { return $null }
    $old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    try { $out = & $c.Source @ArgList 2>&1 | Out-String } catch { $out = '' } finally { $ErrorActionPreference = $old }
    if ($out -match $Regex) { return $Matches[1] }
    return ''
}

function ConvertTo-Version([string]$Text) {
    $t = ($Text -replace '[^\d.].*$', '').Trim('.')
    if (-not $t) { return $null }
    $parts = @($t.Split('.') | Select-Object -First 4)
    while ($parts.Count -lt 2) { $parts += '0' }
    try { return [version]($parts -join '.') } catch { return $null }
}

# 도구 하나의 현재 상태: OK · MISSING · OLD(낮거나 다른 주 버전)
function Get-ToolStatus($Tool) {
    $s = [ordered]@{ Tool = $Tool; Id = $Tool.Id; Name = $Tool.Name; Level = $Tool.Level; Version = ''; State = 'MISSING'; Note = '' }
    if ($Tool.Kind -eq 'app') {
        $hit = @($Tool.Paths | ForEach-Object { [Environment]::ExpandEnvironmentVariables($_) } | Where-Object { Test-Path $_ }) | Select-Object -First 1
        if ($hit -or (Test-WingetPackage $Tool.Winget)) { $s.State = 'OK'; $s.Version = '설치됨' }
        return [pscustomobject]$s
    }
    $v = Get-CmdVersion $Tool.Cmd $Tool.Args $Tool.Regex
    if ($null -eq $v) { return [pscustomobject]$s }
    $s.Version = $(if ($v) { $v } else { '버전 확인 불가' })
    $s.State = 'OK'
    $cur = ConvertTo-Version $v
    # 동작에 문제가 없으면 OK — 권장보다 낮은 버전은 메모만 남긴다
    if ($Tool.Major -and $cur -and $cur.Major -ne $Tool.Major) {
        # Java: PATH 의 java 가 21 이 아니어도 JAVA_HOME 이 21 이면 Gradle 은 그 JDK 로 돈다
        $jh = $env:JAVA_HOME
        $jhJava = $(if ($jh) { Join-Path $jh 'bin\java.exe' } else { $null })
        $jhOk = $false
        if ($jhJava -and (Test-Path $jhJava)) { $jhOk = ((& $jhJava -version 2>&1 | Out-String) -match "version `"$($Tool.Major)[.`"]") }
        if ($jhOk) { $s.Note = "PATH 는 $($cur.Major) · JAVA_HOME 은 $($Tool.Major) — 빌드는 $($Tool.Major) 로 동작" }
        else { $s.State = 'OLD'; $s.Note = "$($Tool.Major) 이 필요 (지금 $($cur.Major)) — JDK $($Tool.Major) 설치 또는 JAVA_HOME 지정" }
    } elseif ($Tool.Min -and $cur -and $cur -lt (ConvertTo-Version $Tool.Min)) {
        $s.Note = "권장 $($Tool.Min) 이상 — 기본 실습은 동작"
    }
    return [pscustomobject]$s
}

function Get-AllStatus { @($Config.Tools | ForEach-Object { Get-ToolStatus $_ }) }

function Show-StatusTable($Statuses) {
    foreach ($s in $Statuses) {
        $text = '{0,-26} {1,-4} {2}' -f $s.Name, $s.Level, $s.Version
        if ($s.Note) { $text += "  ← $($s.Note)" }
        if ($s.State -eq 'MISSING') { $text += '  ← 설치 필요' }
        Write-State $s.State $text
    }
}

function Get-CommandPaths([string]$Cmd) {
    $old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    $paths = @(where.exe $Cmd 2>$null | Where-Object { $_ -and $_ -notlike '*\WindowsApps\*' })
    $ErrorActionPreference = $old
    return @($paths | ForEach-Object { Split-Path $_ -Parent } | Select-Object -Unique)
}

# winget 에 설치된 패키지 중 이름 · ID 가 pattern 에 맞는 것 [{Id, Name}]
function Get-WingetMatches([string]$Pattern) {
    if (-not (Test-Winget)) { return @() }
    $lines = winget list --accept-source-agreements 2>$null
    $found = @()
    foreach ($l in $lines) {
        if ($l -notmatch $Pattern -or $l -match 'ARP\\') { continue }
        # winget list 는 「이름  ID  버전 ...」 형식이다 · ID 는 공백 없는 점 표기 토큰
        if ($l -match '\s([A-Za-z][\w\-]*(?:\.[A-Za-z0-9][\w\-]*)+)\s+\S') { $found += [pscustomobject]@{ Id = $Matches[1]; Name = $l.Trim() } }
    }
    return $found
}

# 충돌 목록 · 항목마다 Detail(설명)과 Action(고칠 때 실행할 scriptblock) · Action 이 없으면 안내만
function Get-Conflicts {
    $list = New-Object System.Collections.ArrayList
    function Add($kind, $detail, $label, $action) {
        [void]$list.Add([pscustomobject]@{ Kind = $kind; Detail = $detail; Label = $label; Action = $action })
    }

    # 1) Java — 21 이 아닌 JDK 가 PATH 앞에 있거나 JAVA_HOME 이 다른 JDK 를 가리키면 Gradle 8.6 · toolchain 21 이 깨진다
    $java = Get-CmdVersion 'java' @('-version') 'version "(\d+)'
    $javaPaths = Get-CommandPaths 'java'
    $jhIs21 = $false
    if ($env:JAVA_HOME -and (Test-Path (Join-Path $env:JAVA_HOME 'bin\java.exe'))) { $jhIs21 = ((& (Join-Path $env:JAVA_HOME 'bin\java.exe') -version 2>&1 | Out-String) -match 'version "21') }
    if ($java -and $java -ne '21' -and -not $jhIs21) { Add 'Java' "PATH 의 java 가 $java 입니다 ($($javaPaths[0])) — 21 이 먼저 와야 한다" '' $null }
    if ($javaPaths.Count -gt 1) { Add 'Java' ("java 가 여러 곳에 있다: " + ($javaPaths -join ' | ')) '' $null }
    if ($env:JAVA_HOME -and -not (Test-Path (Join-Path $env:JAVA_HOME 'bin\java.exe'))) {
        if ([Environment]::GetEnvironmentVariable('JAVA_HOME', 'User')) {
            Add 'Java' "JAVA_HOME 이 없는 폴더를 가리킨다: $env:JAVA_HOME" 'JAVA_HOME 비우기 (사용자 변수)' { [Environment]::SetEnvironmentVariable('JAVA_HOME', $null, 'User'); $env:JAVA_HOME = $null }
        } else {
            Add 'Java' "JAVA_HOME(시스템 변수)이 없는 폴더를 가리킨다: $env:JAVA_HOME — 시스템 환경 변수에서 고친다" '' $null
        }
    } elseif ($env:JAVA_HOME -and ((& (Join-Path $env:JAVA_HOME 'bin\java.exe') -version 2>&1 | Out-String) -notmatch 'version "21')) {
        Add 'Java' "JAVA_HOME 이 21 이 아닌 JDK 를 가리킨다: $env:JAVA_HOME" '' $null
    }
    foreach ($p in Get-WingetMatches '(?i)(jdk|openjdk|temurin|zulu|corretto|java)') {
        if ($p.Id -match '(?i)(^|\.)21(\.|$)') { continue }
        $id = $p.Id
        Add 'Java' "21 이 아닌 JDK 가 설치되어 있다: $($p.Name)" "winget uninstall $id" ([scriptblock]::Create("winget uninstall --id '$id' -e --silent"))
    }

    # 2) Node — 22 미만이거나 node 가 여러 곳 · nvm-windows 와 Node 설치본이 함께 있으면 버전이 엇갈린다
    $node = Get-CmdVersion 'node' @('--version') 'v(\d+)'
    $nodePaths = Get-CommandPaths 'node'
    if ($node -and [int]$node -lt 22) {
        foreach ($p in Get-WingetMatches '(?i)OpenJS\.NodeJS') {
            $id = $p.Id
            Add 'Node' "Node.js $node — 22 이상이 필요하다 ($($p.Name))" "winget uninstall $id (설치 단계에서 LTS 로 다시 설치)" ([scriptblock]::Create("winget uninstall --id '$id' -e --silent"))
        }
    }
    if ($nodePaths.Count -gt 1) { Add 'Node' ("node 가 여러 곳에 있다: " + ($nodePaths -join ' | ')) '' $null }
    if ((Get-Command nvm -ErrorAction SilentlyContinue) -and (Test-WingetPackage 'OpenJS.NodeJS.LTS')) {
        Add 'Node' 'nvm-windows 와 Node.js 설치본이 함께 있다 — 하나만 쓴다' 'winget uninstall OpenJS.NodeJS.LTS (nvm 으로 관리)' { winget uninstall --id 'OpenJS.NodeJS.LTS' -e --silent }
    }

    # 3) Claude Code — npm 전역 설치본과 네이티브 설치본이 함께 있으면 어느 claude 가 도는지 모른다
    $claudePaths = Get-CommandPaths 'claude'
    $npmClaude = $false
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        $old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
        $npmClaude = ((npm ls -g --depth=0 '@anthropic-ai/claude-code' 2>$null | Out-String) -match 'claude-code@')
        $ErrorActionPreference = $old
    }
    if ($npmClaude -and ($claudePaths | Where-Object { $_ -notmatch '\\npm\\' })) {
        Add 'Claude' 'npm 전역 claude 와 네이티브 claude 가 함께 있다' 'npm uninstall -g @anthropic-ai/claude-code' { npm uninstall -g '@anthropic-ai/claude-code' }
    } elseif ($claudePaths.Count -gt 1) {
        Add 'Claude' ("claude 가 여러 곳에 있다: " + ($claudePaths -join ' | ')) '' $null
    }

    # 4) Python — Store 바로가기만 있으면 python 이 설치 창을 띄운다
    $stub = Get-Command python -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($stub -and $stub.Source -like '*\WindowsApps\*' -and -not (Get-CmdVersion 'python' @('--version') 'Python (\d+)')) {
        Add 'Python' 'python 이 Microsoft Store 바로가기다 — 설정 > 앱 > 고급 앱 설정 > 앱 실행 별칭에서 python 을 끈다' '' $null
    }

    # 5) 포트 — 실습 서비스(8080 · 5173)를 다른 프로그램이 쓰고 있다
    foreach ($port in $Config.Ports) {
        $conns = @(Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.OwningProcess -gt 4 } | Sort-Object OwningProcess -Unique)
        foreach ($c in $conns) {
            $proc = Get-Process -Id $c.OwningProcess -ErrorAction SilentlyContinue
            $name = $(if ($proc) { $proc.ProcessName } else { '?' })
            $procId = $c.OwningProcess
            Add '포트' "$port 번을 $name (PID $procId) 가 쓰고 있다" "프로세스 종료 PID $procId" ([scriptblock]::Create("Stop-Process -Id $procId -Force"))
        }
    }
    return $list
}

# 충돌을 보여 주고 번호를 골라 고친다 · Action 이 없는 항목은 안내만
function Invoke-ConflictMenu($Conflicts) {
    if (-not $Conflicts -or $Conflicts.Count -eq 0) { Write-State OK '충돌 없음'; return }
    $i = 0
    foreach ($c in $Conflicts) {
        $i++
        $fix = $(if ($c.Action) { "→ [$i] $($c.Label)" } else { '→ 직접 확인' })
        Write-State WARN ("{0}. [{1}] {2}" -f $i, $c.Kind, $c.Detail)
        Write-Host "             $fix" -ForegroundColor DarkGray
    }
    $fixable = @($Conflicts | Where-Object { $_.Action })
    if ($fixable.Count -eq 0) { return }
    Write-Host ''
    $answer = Read-Host '삭제 · 종료할 번호 (예: 1,3 · all · 엔터 = 건너뜀)'
    if (-not $answer) { return }
    $picks = $(if ($answer -eq 'all') { 1..$Conflicts.Count } else { $answer -split '[,\s]+' | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ } | Sort-Object -Unique })
    foreach ($n in $picks) {
        if ($n -lt 1 -or $n -gt $Conflicts.Count) { continue }
        $c = $Conflicts[$n - 1]
        if (-not $c.Action) { Write-State INFO "$n 번은 자동으로 고칠 수 없다 — $($c.Detail)"; continue }
        $ok = Read-Host "  $n. $($c.Label) 를 실행할까요? (y/N)"
        if ($ok -notmatch '^[yY]') { continue }
        try {
            $ErrorActionPreference = 'Stop'; $global:LASTEXITCODE = 0
            & $c.Action
            if ($LASTEXITCODE) { throw "종료 코드 $LASTEXITCODE" }
            Write-State OK "$n. $($c.Label)"
        } catch { Write-State FAIL "$n. $($c.Label) — $($_.Exception.Message)" } finally { $ErrorActionPreference = 'Continue' }
    }
    Update-SessionPath
}

function Test-Hosts {
    foreach ($h in $Config.Hosts) {
        $ok = $false
        try { $ok = (Test-NetConnection -ComputerName $h -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue) } catch { }
        if ($ok) { Write-State OK "${h}:443" } else { Write-State FAIL "${h}:443 접속 실패 — 사내망이면 프록시 설정 확인" }
    }
}
