@echo off
chcp 65001 > nul
rem Swagger UI 열기 - 서비스가 실행 중이어야 합니다
echo [edu-stock-chart] Swagger UI를 엽니다.
echo   서비스가 꺼져 있으면 scripts\run.bat 을 먼저 실행하세요.
start "" http://localhost:8080/swagger-ui.html
