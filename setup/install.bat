@echo off
chcp 65001 > nul
rem 실습 사전 준비 - Git, Node.js, JDK 21 설치 (이미 있으면 건너뜀)
rem 사용: 더블클릭 또는 setup\install.bat

where winget > nul 2>&1
if errorlevel 1 (
  echo [오류] winget 이 없습니다. Microsoft Store 에서 "앱 설치 관리자"를 업데이트한 뒤 다시 실행하세요.
  pause
  exit /b 1
)

echo.
echo === 1/3 Git ===
call :ensure git Git.Git

echo.
echo === 2/3 Node.js LTS (npm, npx 포함) ===
call :ensure node OpenJS.NodeJS.LTS

echo.
echo === 3/3 JDK 21 (Azul Zulu) ===
call :ensure java Azul.Zulu.21.JDK

echo.
echo 설치가 끝났습니다. PATH 반영을 위해 터미널을 닫고 새로 연 뒤 setup\verify.bat 을 실행하세요.
pause
exit /b 0

:ensure
where %1 > nul 2>&1
if not errorlevel 1 (
  echo   %1 이미 설치되어 있습니다. 건너뜁니다.
  exit /b 0
)
echo   %2 설치 중...
winget install --id %2 -e --silent --accept-package-agreements --accept-source-agreements
exit /b 0
