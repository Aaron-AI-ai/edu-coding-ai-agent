@echo off
chcp 65001 > nul
rem API 서버 · UI 중지 - Windows
setlocal
set "RUN=%~dp0..\.run"
call :stop "API 서버" api
call :stop "UI" ui
exit /b 0

:stop
if not exist "%RUN%\%2.pid" (echo [--] %~1 실행 기록 없음 & exit /b 0)
set /p PID=<"%RUN%\%2.pid"
taskkill /PID %PID% /T /F > nul 2>&1 && (echo [OK] %~1 중지 ^(pid %PID%^)) || (echo [--] %~1 이미 중지됨)
del "%RUN%\%2.pid"
exit /b 0
