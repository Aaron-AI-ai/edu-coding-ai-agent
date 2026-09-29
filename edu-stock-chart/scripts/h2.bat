@echo off
chcp 65001 > nul
rem H2 콘솔 열기 - 서비스가 실행 중이어야 합니다
echo [edu-stock-chart] H2 콘솔을 엽니다.
echo   JDBC URL : jdbc:h2:mem:stockchart
echo   User     : sa
echo   Password : (비움)
start "" http://localhost:8080/h2-console
