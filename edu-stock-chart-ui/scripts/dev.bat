@echo off
chcp 65001 > nul
rem 개발 서버 실행 - http://localhost:5173
pushd "%~dp0.."
if not exist node_modules (
  echo [edu-stock-chart-ui] 최초 실행: 의존성을 설치합니다.
  call npm install
)
echo [edu-stock-chart-ui] 개발 서버를 시작합니다. 종료하려면 Ctrl+C
echo   UI   http://localhost:5173
echo   API  /api 요청은 http://localhost:8080 으로 전달됩니다
echo.
call npm run dev
popd
