# Swagger UI 열기 - 서비스가 실행 중이어야 합니다
Write-Host '[edu-stock-chart] Swagger UI를 엽니다.'
Write-Host '  서비스가 꺼져 있으면 scripts\run.ps1 을 먼저 실행하세요.'
Start-Process 'http://localhost:8080/swagger-ui.html'
