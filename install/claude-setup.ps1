# 4단계 · Claude Code 플러그인 · Skill — 강의에서 쓰는 것 중 없는 것만 골라 설치한다
# 먼저 claude 를 한 번 실행해 로그인해 둔다. 서드파티 플러그인은 훅 · MCP 를 실행할 수 있으니 목록을 보고 고른다.
# 사용: install\4-claude-setup.bat   (묻지 않고 전부: -Yes)
param([switch]$Yes)
. (Join-Path $PSScriptRoot 'lib\common.ps1')

Update-SessionPath
Add-UserPath (Join-Path $env:USERPROFILE '.local\bin')   # 네이티브 claude · uv tool 설치 위치
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-State FAIL 'claude 가 없다 — 3-install.bat 을 먼저 실행하고 새 터미널에서 다시 실행한다'
    Exit-Script 1
}

function Invoke-Quiet([string]$Line) {
    $old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    $out = cmd /c "$Line 2>&1" | Out-String
    $ErrorActionPreference = $old
    return $out
}

$skillDirs = @((Join-Path $env:USERPROFILE '.claude\skills'), (Join-Path $env:USERPROFILE '.agents\skills'))
function Test-Skill([string]$Pattern) {
    foreach ($d in $skillDirs) {
        if ((Test-Path $d) -and (Get-ChildItem $d -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $Pattern })) { return $true }
    }
    return $false
}

$markets = Invoke-Quiet 'claude plugin marketplace list'
$plugins = Invoke-Quiet 'claude plugin list'

# Type: market · plugin · skill · eli5 · graphify   /  Test: 설치 여부   /  Run: 설치 명령
$items = @(
    @{ Name = '마켓 claude-plugins-official'; Type = 'market'; Test = { $markets -match 'claude-plugins-official' }; Run = 'claude plugin marketplace add anthropics/claude-plugins-official' }
    @{ Name = '마켓 hyperframes';            Type = 'market'; Test = { $markets -match '\bhyperframes\b' };          Run = 'claude plugin marketplace add heygen-com/hyperframes' }
    @{ Name = '마켓 ponytail';               Type = 'market'; Test = { $markets -match '\bponytail\b' };             Run = 'claude plugin marketplace add DietrichGebert/ponytail' }
    @{ Name = '마켓 thedotmack (claude-mem)'; Type = 'market'; Test = { $markets -match '\bthedotmack\b' };          Run = 'claude plugin marketplace add thedotmack/claude-mem' }
    @{ Name = '마켓 obsidian-second-brain';  Type = 'market'; Test = { $markets -match 'obsidian-second-brain' };    Run = 'claude plugin marketplace add eugeniughelbur/obsidian-second-brain' }
    @{ Name = 'superpowers';           Type = 'plugin'; Test = { $plugins -match '\bsuperpowers\b' };           Run = 'claude plugin install superpowers@claude-plugins-official' }
    @{ Name = 'playwright';            Type = 'plugin'; Test = { $plugins -match '\bplaywright\b' };            Run = 'claude plugin install playwright@claude-plugins-official' }
    @{ Name = 'context7';              Type = 'plugin'; Test = { $plugins -match '\bcontext7\b' };              Run = 'claude plugin install context7@claude-plugins-official' }
    @{ Name = 'skill-creator';         Type = 'plugin'; Test = { $plugins -match '\bskill-creator\b' };         Run = 'claude plugin install skill-creator@claude-plugins-official' }
    @{ Name = 'hyperframes';           Type = 'plugin'; Test = { $plugins -match 'hyperframes@' };              Run = 'claude plugin install hyperframes@hyperframes' }
    @{ Name = 'ponytail';              Type = 'plugin'; Test = { $plugins -match 'ponytail@' };                 Run = 'claude plugin install ponytail@ponytail' }
    @{ Name = 'claude-mem';            Type = 'plugin'; Test = { $plugins -match '\bclaude-mem@' };             Run = 'claude plugin install claude-mem@thedotmack' }
    @{ Name = 'obsidian-second-brain'; Type = 'plugin'; Test = { $plugins -match 'obsidian-second-brain@' };    Run = 'claude plugin install obsidian-second-brain@obsidian-second-brain' }
    @{ Name = 'Skill archify';         Type = 'skill';  Test = { Test-Skill '^archify$' };                      Run = 'npx -y skills add tt-a1i/archify -g --agent claude-code' }
    @{ Name = 'Skill drawio-skill';    Type = 'skill';  Test = { Test-Skill 'drawio' };                         Run = 'npx -y skills add Agents365-ai/drawio-skill -g --agent claude-code' }
    @{ Name = 'Skill hallmark';        Type = 'skill';  Test = { Test-Skill '^hallmark$' };                     Run = 'npx -y skills add nutlope/hallmark -g --agent claude-code' }
    @{ Name = 'Skill eli5';            Type = 'eli5';   Test = { Test-Skill '^eli5$' };                         Run = 'git clone https://github.com/DreambigOu/ELI5.git → ~\.claude\skills\eli5' }
    @{ Name = 'graphify (uv)';         Type = 'graphify'; Test = { [bool](Get-Command graphify -ErrorAction SilentlyContinue) -and (Test-Skill '^graphify$') }; Run = 'uv tool install graphifyy → graphify install' }
)

Write-Title '플러그인 · Skill 상태'
$todo = @()
$i = 0
foreach ($it in $items) {
    $ok = [bool](& $it.Test)
    if ($ok) { Write-State OK $it.Name } else { $i++; $todo += $it; Write-State MISSING ("{0}. {1}  — {2}" -f $i, $it.Name, $it.Run) }
}
if ($todo.Count -eq 0) { Write-State OK '모두 설치되어 있다'; Exit-Script 0 }

if (-not $Yes) {
    $answer = Read-Host "`n설치할 번호 (예: 1,4 · 엔터 = 전부 · n = 취소)"
    if ($answer -match '^[nN]') { Exit-Script 0 }
    if ($answer) {
        $picks = $answer -split '[,\s]+' | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ } | Sort-Object -Unique
        $todo = @($picks | Where-Object { $_ -ge 1 -and $_ -le $todo.Count } | ForEach-Object { $todo[$_ - 1] })
    }
}

# 마켓을 먼저 추가해야 플러그인을 찾는다
$failed = 0
$order = @{ market = 0; plugin = 1 }
$todo = @($todo | Sort-Object { $o = $order[$_.Type]; if ($null -eq $o) { 2 } else { $o } })
foreach ($it in $todo) {
    Write-Title $it.Name
    $old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    switch ($it.Type) {
        'eli5' {
            $src = Join-Path $env:TEMP 'eli5-src'
            if (Test-Path $src) { Remove-Item $src -Recurse -Force }
            git clone --depth 1 https://github.com/DreambigOu/ELI5.git $src
            $dst = Join-Path $env:USERPROFILE '.claude\skills'
            New-Item -ItemType Directory -Force $dst | Out-Null
            Copy-Item -Recurse -Force (Join-Path $src 'skills\eli5') (Join-Path $dst 'eli5')
        }
        'graphify' {
            if (-not (Get-Command uv -ErrorAction SilentlyContinue)) { Write-State FAIL 'uv 가 없다 — 3-install.bat 으로 uv 를 설치한다'; break }
            if (-not (Get-Command graphify -ErrorAction SilentlyContinue)) { uv tool install graphifyy; Update-SessionPath; Add-UserPath (Join-Path $env:USERPROFILE '.local\bin') }
            graphify install
        }
        default { cmd /c $it.Run }
    }
    $ErrorActionPreference = $old
    if ($it.Type -eq 'market') { $markets = Invoke-Quiet 'claude plugin marketplace list' }
    if ($it.Type -eq 'plugin') { $plugins = Invoke-Quiet 'claude plugin list' }
    if (& $it.Test) { Write-State OK $it.Name } else { Write-State FAIL "$($it.Name) — 위 출력을 확인한다"; $failed++ }
}

Write-Host ''
Write-Host '  claude 를 다시 시작해야 새 플러그인 · Skill 이 보인다 (/plugin · /skills 로 확인)' -ForegroundColor DarkGray
if ($failed -gt 0) { Exit-Script 1 } else { Exit-Script 0 }
