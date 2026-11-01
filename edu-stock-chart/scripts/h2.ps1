# H2 콘솔 열기 - 서비스가 실행 중이어야 합니다
Write-Host '[edu-stock-chart] H2 콘솔을 엽니다.'
Write-Host '  JDBC URL : jdbc:h2:mem:stockchart'
Write-Host '  User     : sa'
Write-Host '  Password : (비움)'
Start-Process 'http://localhost:8080/h2-console'
