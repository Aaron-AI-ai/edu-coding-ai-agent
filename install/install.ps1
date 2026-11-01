# 3단계 · 설치 — 점검해서 없거나 버전이 낮은 것만 골라 설치한다
# 순서: winget → install\packages 의 설치 파일 → 공식 설치 스크립트
# 사용: install\3-install.bat   (묻지 않고: -Yes · 받은 파일만: -Offline · 필수만: -RequiredOnly · 의존성 미리 받기 생략: -SkipWarmup)
param([switch]$Yes, [switch]$Offline, [switch]$RequiredOnly, [switch]$SkipWarmup)
. (Join-Path $PSScriptRoot 'lib\common.ps1')

Update-SessionPath

Write-Title '현재 상태'
$statuses = Get-AllStatus
Show-StatusTable $statuses
$todo = @($statuses | Where-Object { $_.State -ne 'OK' -and (-not $RequiredOnly -or $_.Level -eq '필수') })

if ($todo.Count -eq 0) {
    Write-State OK '설치할 것이 없다'
} else {
    Write-Title '설치 대상'
    $i = 0
    foreach ($s in $todo) { $i++; Write-Host ("  {0}. {1,-26} {2}  — {3}" -f $i, $s.Name, $s.Level, $s.Tool.Why) }
    if (-not $Yes) {
        $answer = Read-Host '설치할 번호 (예: 1,2 · 엔터 = 전부 · n = 취소)'
        if ($answer -match '^[nN]') { Exit-Script 0 }
        if ($answer) {
            $picks = $answer -split '[,\s]+' | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ } | Sort-Object -Unique
            $todo = @($picks | Where-Object { $_ -ge 1 -and $_ -le $todo.Count } | ForEach-Object { $todo[$_ - 1] })
        }
    }
    $conflicts = @(Get-Conflicts | Where-Object { $_.Kind -in @('Java', 'Node', 'Claude') })
    if ($conflicts.Count -gt 0) {
        Write-State WARN '충돌이 있다 — 설치 뒤에도 남으면 1-check.bat 에서 골라 정리한다'
    }
}

function Get-LocalInstaller([string]$Id) {
    $dir = Join-Path $PackageDir $Id
    if (-not (Test-Path $dir)) { return $null }
    Get-ChildItem $dir -Recurse -File -Include *.msi, *.exe -ErrorAction SilentlyContinue | Select-Object -First 1
}

function Install-Tool($Status) {
    $t = $Status.Tool
    Write-Title "$($t.Name) 설치"
    # 1) winget — 이미 있지만 버전이 낮으면 upgrade
    if (-not $Offline -and $t.Winget -and (Test-Winget)) {
        $verb = $(if ($Status.State -eq 'OLD' -and (Test-WingetPackage $t.Winget)) { 'upgrade' } else { 'install' })
        $old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
        winget $verb --id $t.Winget -e --silent --accept-package-agreements --accept-source-agreements
        $ErrorActionPreference = $old
        Update-SessionPath
        if ((Get-ToolStatus $t).State -eq 'OK') { return $true }
    }
    # 2) 받아 둔 설치 파일
    $file = Get-LocalInstaller $t.Id
    if ($file) {
        Write-State INFO "받아 둔 파일로 설치: $($file.Name)"
        $proc = $null
        if ($file.Extension -eq '.msi') {
            # 컴퓨터 전체 설치 MSI 는 관리자 권한이 필요하다 → UAC 확인 창
            $proc = Start-Process msiexec.exe -ArgumentList @('/i', "`"$($file.FullName)`"", '/qn', '/norestart') -Verb RunAs -Wait -PassThru
        } elseif ($t.Silent) {
            $proc = Start-Process $file.FullName -ArgumentList $t.Silent -Wait -PassThru
        } else {
            Write-State WARN "$($file.Name) 는 무인 설치 옵션을 모른다 — 파일을 직접 실행해 설치한다"
        }
        if ($proc -and @(0, 3010) -notcontains $proc.ExitCode) { Write-State WARN "설치 프로그램 종료 코드 $($proc.ExitCode)" }
        Update-SessionPath
        if ((Get-ToolStatus $t).State -eq 'OK') { return $true }
    }
    # 3) 공식 설치 스크립트
    if (-not $Offline -and $t.Script) {
        Write-State INFO "공식 스크립트로 설치: $($t.Script)"
        powershell -NoProfile -ExecutionPolicy Bypass -Command $t.Script
        Update-SessionPath
        # 네이티브 claude · uv 는 ~\.local\bin 에 들어간다 → 사용자 PATH 에 영구로
        Add-UserPath (Join-Path $env:USERPROFILE '.local\bin')
        if ((Get-ToolStatus $t).State -eq 'OK') { return $true }
    }
    return $false
}

# JAVA_HOME 이 비었거나 21 이 아니면 설치된 JDK 21 로 맞춘다 (사용자 변수)
function Set-JavaHome {
    $cur = $env:JAVA_HOME
    if ($cur -and (Test-Path (Join-Path $cur 'bin\java.exe')) -and ((& (Join-Path $cur 'bin\java.exe') -version 2>&1 | Out-String) -match 'version "21')) { return }
    $jdk = @(Get-ChildItem "$env:ProgramFiles\Zulu", "$env:ProgramFiles\Eclipse Adoptium", "$env:ProgramFiles\Java" -Directory -ErrorAction SilentlyContinue |
             Where-Object { $_.Name -match '21' -and (Test-Path (Join-Path $_.FullName 'bin\java.exe')) }) | Select-Object -First 1
    if ($jdk) {
        [Environment]::SetEnvironmentVariable('JAVA_HOME', $jdk.FullName, 'User')
        $env:JAVA_HOME = $jdk.FullName
        Write-State OK "JAVA_HOME = $($jdk.FullName)"
    }
}

$failed = @()
foreach ($s in $todo) {
    if (Install-Tool $s) { Write-State OK "$($s.Name) 설치 완료" } else { Write-State FAIL "$($s.Name) 설치 실패"; $failed += $s.Name }
    if ($s.Id -eq 'java') { Set-JavaHome }
}

# 프로젝트 의존성 미리 받기 — 교실에서 처음 빌드할 때 기다리지 않도록
if (-not $SkipWarmup -and (Get-ToolStatus ($Config.Tools | Where-Object { $_.Id -eq 'java' })).State -eq 'OK' -and (Get-ToolStatus ($Config.Tools | Where-Object { $_.Id -eq 'node' })).State -eq 'OK') {
    $go = $(if ($Yes) { 'y' } else { Read-Host "`n실습 프로젝트 의존성(Gradle · npm)을 미리 받을까요? (Y/n)" })
    if ($go -notmatch '^[nN]') {
        Write-Title '의존성 미리 받기'
        $old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
        $g = 1; $n = 1
        $api = Join-Path $RepoRoot 'edu-stock-chart'; $ui = Join-Path $RepoRoot 'edu-stock-chart-ui'
        if (Test-Path $api) { Push-Location $api; cmd /c "gradlew.bat bootJar -q --no-daemon"; $g = $LASTEXITCODE; Pop-Location } else { Write-State WARN "폴더 없음: $api" }
        if (Test-Path $ui)  { Push-Location $ui;  cmd /c "npm install --no-fund --no-audit"; $n = $LASTEXITCODE; Pop-Location } else { Write-State WARN "폴더 없음: $ui" }
        $ErrorActionPreference = $old
        if ($g -eq 0) { Write-State OK 'edu-stock-chart 빌드' } else { Write-State FAIL 'edu-stock-chart 빌드 — 1-check.bat 으로 Java 충돌 확인' }
        if ($n -eq 0) { Write-State OK 'edu-stock-chart-ui npm install' } else { Write-State FAIL 'edu-stock-chart-ui npm install — 프록시 · Node 버전 확인' }
    }
}

Write-Title '다음'
if ($failed.Count -gt 0) { Write-State FAIL ("실패: " + ($failed -join ', ') + " — 로그를 보고 다시 실행하거나 수동 설치") }
Write-Host '  1. 터미널을 모두 닫고 새로 연다 (PATH 반영)'
Write-Host '  2. install\1-check.bat 으로 다시 점검'
Write-Host '  3. claude 로그인 후 install\4-claude-setup.bat 으로 플러그인 · Skill 설치'
if ($failed.Count -gt 0) { Exit-Script 1 } else { Exit-Script 0 }
