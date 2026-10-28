@echo off
chcp 65001 > nul
rem API 서버 · UI 실행 상태 - Windows
setlocal
set "RUN=%~dp0..\.run"
call :show "API 서버" api 8080 http://localhost:8080/swagger-ui.html
call :show "UI      " ui 5173 http://localhost:5173
exit /b 0

:show
set "PID="
set "ALIVE="
set "OPEN="
if exist "%RUN%\%2.pid" set /p PID=<"%RUN%\%2.pid"
if defined PID tasklist /FI "PID eq %PID%" /NH | findstr /c:" %PID% " > nul && set ALIVE=1
netstat -ano | findstr /r /c:":%3 .*LISTENING" > nul && set OPEN=1
if defined ALIVE (
  if defined OPEN (echo [OK] %~1 실행 중 ^(pid %PID%^) %4) else (echo [..] %~1 기동 중 ^(pid %PID% · 포트 %3 대기^))
) else (
  if defined OPEN (echo [!]  %~1 포트 %3 을 다른 프로세스가 쓰고 있습니다) else (echo [--] %~1 중지됨)
)
exit /b 0
