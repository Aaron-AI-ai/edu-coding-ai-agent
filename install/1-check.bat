@echo off
chcp 65001 > nul
rem 1단계 · 현재 상태 점검 (도구 · 버전 · 충돌 · 접속) — 충돌은 골라서 삭제
rem 옵션은 그대로 넘긴다 (예: 1-check.bat -ReportOnly)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0check.ps1" %*
set "RC=%ERRORLEVEL%"
echo.
pause
exit /b %RC%
