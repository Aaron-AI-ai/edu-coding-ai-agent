@echo off
chcp 65001 > nul
rem 2단계(선택) · 설치 파일을 install\packages 에 미리 받기
rem 옵션은 그대로 넘긴다 (예: 2-download.bat -Only git,node,java)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0download.ps1" %*
set "RC=%ERRORLEVEL%"
exit /b %RC%
