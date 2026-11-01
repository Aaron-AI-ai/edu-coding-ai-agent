@echo off
chcp 65001 > nul
rem 3단계 · 없거나 버전이 낮은 것만 설치
rem 옵션은 그대로 넘긴다 (예: 3-install.bat -Yes)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
set "RC=%ERRORLEVEL%"
exit /b %RC%
