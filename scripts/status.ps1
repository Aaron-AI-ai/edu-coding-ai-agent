# API 서버 · UI 실행 상태 - Windows PowerShell
$Run = Join-Path $PSScriptRoot '..\.run'

function Show($name, $key, $port, $url) {
  $pidFile = Join-Path $Run "$key.pid"
  $procId = if (Test-Path $pidFile) { (Get-Content $pidFile -TotalCount 1).Trim() }
  $alive = $procId -and (Get-Process -Id $procId -ErrorAction SilentlyContinue)
  $open = [bool](Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue)
  if ($alive) {
    if ($open) { Write-Host "[OK] $name 실행 중 (pid $procId) $url" } else { Write-Host "[..] $name 기동 중 (pid $procId · 포트 $port 대기)" }
  } elseif ($open) {
    Write-Host "[!]  $name 포트 $port 을 다른 프로세스가 쓰고 있습니다"
  } else {
    Write-Host "[--] $name 중지됨"
  }
}

Show 'API 서버' api 8080 http://localhost:8080/swagger-ui.html
Show 'UI      ' ui 5173 http://localhost:5173
