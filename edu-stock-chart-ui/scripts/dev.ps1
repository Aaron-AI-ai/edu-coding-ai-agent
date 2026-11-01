# 개발 서버 실행 - http://localhost:5173
Push-Location (Join-Path $PSScriptRoot '..')
try {
  if (-not (Test-Path node_modules)) {
    Write-Host '[edu-stock-chart-ui] 최초 실행: 의존성을 설치합니다.'
    npm install
  }
  Write-Host '[edu-stock-chart-ui] 개발 서버를 시작합니다. 종료하려면 Ctrl+C'
  Write-Host '  UI   http://localhost:5173'
  Write-Host '  API  /api 요청은 http://localhost:8080 으로 전달됩니다'
  Write-Host ''
  npm run dev
} finally { Pop-Location }
