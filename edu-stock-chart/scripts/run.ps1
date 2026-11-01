# 서비스 실행 - http://localhost:8080
Push-Location (Join-Path $PSScriptRoot '..')
try {
  Write-Host '[edu-stock-chart] 서비스를 시작합니다. 종료하려면 Ctrl+C'
  Write-Host '  Swagger  http://localhost:8080/swagger-ui.html'
  Write-Host '  H2       http://localhost:8080/h2-console'
  Write-Host ''
  & .\scripts\gradlew.ps1 bootRun
} finally { Pop-Location }
