# 2단계(선택) · 설치 파일 미리 받기 — 인터넷이 느리거나 막힌 교실에 USB · 공유 폴더로 나눠 줄 때
# install\packages\<Id>\ 에 설치 파일을 받는다. install.ps1 은 winget 이 안 되면 이 파일로 설치한다.
# 사용: install\2-download.bat   (일부만: -Only git,node,java)
param([string[]]$Only)
# powershell -File 은 git,node 를 문자열 하나로 넘긴다
if ($Only) { $Only = @($Only -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }) }
. (Join-Path $PSScriptRoot 'lib\common.ps1')

New-Item -ItemType Directory -Force $PackageDir | Out-Null
$tools = @($Config.Tools | Where-Object { -not $Only -or $Only -contains $_.Id })

function Get-LocalInstaller([string]$Id) {
    $dir = Join-Path $PackageDir $Id
    if (-not (Test-Path $dir)) { return $null }
    Get-ChildItem $dir -Recurse -File -Include *.msi, *.exe, *.msix, *.zip -ErrorAction SilentlyContinue | Select-Object -First 1
}

function Save-GitHubAsset([string]$Repo, [string]$Pattern, [string]$Dir) {
    $rel = Invoke-RestMethod "https://api.github.com/repos/$Repo/releases/latest" -Headers @{ 'User-Agent' = 'edu-install' } -ErrorAction Stop
    $asset = $rel.assets | Where-Object { $_.name -match $Pattern -and $_.name -notmatch '(?i)(arm64|blockmap|\.sig)' } | Select-Object -First 1
    if (-not $asset) { throw "$Repo 최신 릴리스에 맞는 파일이 없다" }
    New-Item -ItemType Directory -Force $Dir | Out-Null
    $out = Join-Path $Dir $asset.name
    Invoke-WebRequest $asset.browser_download_url -OutFile $out -UseBasicParsing -ErrorAction Stop
    return $out
}

Write-Title "설치 파일 받기 → $PackageDir"
foreach ($t in $tools) {
    $have = Get-LocalInstaller $t.Id
    if ($have) { Write-State OK "$($t.Name) — 이미 있음 ($($have.Name))"; continue }
    $dir = Join-Path $PackageDir $t.Id
    $done = $false
    if ($t.Winget -and (Test-Winget)) {
        $old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
        winget download --id $t.Winget -e -d $dir --accept-package-agreements --accept-source-agreements | Out-Null
        $ErrorActionPreference = $old
        $done = [bool](Get-LocalInstaller $t.Id)
    }
    if (-not $done -and $t.GitHub) {
        try { $f = Save-GitHubAsset $t.GitHub $t.Asset $dir; $done = $true } catch { Write-State WARN "$($t.Name) — GitHub 받기 실패: $($_.Exception.Message)" }
    }
    if ($done) { Write-State OK "$($t.Name) — $((Get-LocalInstaller $t.Id).Name)" }
    elseif ($t.Script) { Write-State INFO "$($t.Name) — 설치 파일 대신 공식 스크립트로 설치한다 ($($t.Script))" }
    else { Write-State FAIL "$($t.Name) — 받지 못했다 (winget 1.8 이상 필요 · 사내망이면 프록시 확인)" }
}

Write-Host ''
Write-Host '  install 폴더를 통째로 복사해 가면 교육 PC 에서 3-install.bat 이 받은 파일로 설치한다.' -ForegroundColor DarkGray
Exit-Script 0
