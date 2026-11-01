@echo off
chcp 65001 > nul
rem 4단계 · Claude Code 플러그인 · Skill 중 없는 것만 설치
rem 옵션은 그대로 넘긴다 (예: 4-claude-setup.bat -Yes)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0claude-setup.ps1" %*
set "RC=%ERRORLEVEL%"
echo.
pause
exit /b %RC%
