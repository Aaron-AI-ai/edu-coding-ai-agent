# 1단계 · 현재 상태 점검 — 도구 설치 · 버전, 충돌, 접속 · 충돌은 번호를 골라 삭제할 수 있다
# 사용: install\1-check.bat  (보고만: powershell -File install\check.ps1 -ReportOnly)
param([switch]$ReportOnly)
. (Join-Path $PSScriptRoot 'lib\common.ps1')

Update-SessionPath

Write-Title '도구 설치 · 버전'
if (-not (Test-Winget)) { Write-State WARN 'winget 이 없다 — Microsoft Store 에서 「앱 설치 관리자」를 업데이트한다 (설치 단계에 필요)' }
$statuses = Get-AllStatus
Show-StatusTable $statuses

Write-Title '충돌'
$conflicts = @(Get-Conflicts)
if ($ReportOnly) {
    if ($conflicts.Count -eq 0) { Write-State OK '충돌 없음' }
    $conflicts | ForEach-Object { Write-State WARN "[$($_.Kind)] $($_.Detail)" }
} else {
    Invoke-ConflictMenu $conflicts
}

Write-Title '접속'
Test-Hosts

$need = @($statuses | Where-Object { $_.State -ne 'OK' })
$mustNeed = @($need | Where-Object { $_.Level -eq '필수' })
Write-Title '요약'
if ($need.Count -eq 0) {
    Write-State OK '모든 도구가 준비되었다 → 4-claude-setup.bat 으로 플러그인 · Skill 을 확인한다'
} else {
    Write-State WARN ("설치 · 업데이트 필요: " + (($need | ForEach-Object { $_.Name }) -join ', '))
    Write-Host '             → 3-install.bat 이 이 항목만 골라 설치한다' -ForegroundColor DarkGray
}
if ($mustNeed.Count -gt 0) { exit 1 } else { exit 0 }
