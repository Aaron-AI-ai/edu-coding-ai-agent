# API 서버 · UI 중지 - Windows PowerShell
$Run = Join-Path $PSScriptRoot '..\.run'

function Stop-One($name, $key) {
  $pidFile = Join-Path $Run "$key.pid"
  if (-not (Test-Path $pidFile)) { Write-Host "[--] $name 실행 기록 없음"; return }
  $procId = (Get-Content $pidFile -TotalCount 1).Trim()
  # /T: 자식 프로세스까지 함께 끈다
  taskkill /PID $procId /T /F 2>$null | Out-Null
  if ($LASTEXITCODE -eq 0) { Write-Host "[OK] $name 중지 (pid $procId)" } else { Write-Host "[--] $name 이미 중지됨" }
  Remove-Item $pidFile
}

Stop-One 'API 서버' api
Stop-One 'UI' ui
