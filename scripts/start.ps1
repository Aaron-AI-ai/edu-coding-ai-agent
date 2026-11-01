# 새로 빌드한 뒤 API 서버(8080)와 UI(5173)를 백그라운드로 실행 - Windows PowerShell
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$Run = Join-Path $Root '.run'
New-Item -ItemType Directory -Force $Run | Out-Null

function Test-Port($port) { [bool](Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue) }

foreach ($port in 8080, 5173) {
  if (Test-Port $port) {
    Write-Host "[X] 포트 $port 를 이미 쓰고 있습니다. 먼저 scripts\stop.ps1 을 실행하세요"
    exit 1
  }
}

Write-Host '[1/4] API 서버 빌드 (테스트 제외 · 테스트는 edu-stock-chart\scripts\test.ps1)'
Push-Location (Join-Path $Root 'edu-stock-chart')
& .\scripts\gradlew.ps1 clean bootJar -q   # .bat 을 거치지 않는다 (액세스 거부 대비)
if ($LASTEXITCODE -ne 0) { Pop-Location; exit 1 }
$Jar = (Get-ChildItem build\libs\*.jar | Where-Object Name -notmatch 'plain' | Select-Object -First 1).FullName
Pop-Location

Write-Host '[2/4] UI 빌드'
Push-Location (Join-Path $Root 'edu-stock-chart-ui')
if (-not (Test-Path node_modules)) {
  npm install
  if ($LASTEXITCODE -ne 0) { Pop-Location; exit 1 }
}
npm run build --silent
if ($LASTEXITCODE -ne 0) { Pop-Location; exit 1 }
Pop-Location

Write-Host '[3/4] 실행'
$api = Start-Process java -ArgumentList '-jar', "`"$Jar`"" -WorkingDirectory (Join-Path $Root 'edu-stock-chart') `
  -RedirectStandardOutput "$Run\api.log" -RedirectStandardError "$Run\api.err.log" -WindowStyle Hidden -PassThru
$api.Id | Out-File -Encoding ascii "$Run\api.pid"
$ui = Start-Process node -ArgumentList 'node_modules\vite\bin\vite.js', 'preview', '--host', '127.0.0.1', '--port', '5173', '--strictPort' `
  -WorkingDirectory (Join-Path $Root 'edu-stock-chart-ui') `
  -RedirectStandardOutput "$Run\ui.log" -RedirectStandardError "$Run\ui.err.log" -WindowStyle Hidden -PassThru
$ui.Id | Out-File -Encoding ascii "$Run\ui.pid"

Write-Host '[4/4] 기동 대기 (최대 60초)'
for ($i = 0; $i -lt 60; $i++) {
  try {
    Invoke-WebRequest http://localhost:8080/api/dashboard/indices -UseBasicParsing -TimeoutSec 2 | Out-Null
    if (Test-Port 5173) {
      Write-Host ''
      Write-Host '[OK] 실행 완료'
      Write-Host '  대시보드  http://localhost:5173'
      Write-Host '  Swagger   http://localhost:8080/swagger-ui.html'
      Write-Host '  로그      .run\api.log · .run\ui.log'
      exit 0
    }
  } catch {}
  Start-Sleep -Seconds 1
}
Write-Host '[X] 60초 안에 뜨지 않았습니다. .run\api.log · .run\ui.log 를 확인하세요'
exit 1
