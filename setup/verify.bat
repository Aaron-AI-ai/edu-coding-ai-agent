@echo off
chcp 65001 > nul
setlocal
rem 실습 사전 준비 검증 - 도구 설치 여부, 버전, 네트워크 접근
rem 사용: setup\verify.bat  (모두 OK 이면 종료 코드 0)

set FAIL=0

echo.
echo === 도구 ===
call :tool git      "git --version"
call :tool node     "node -v"
call :tool npm      "npm -v"
call :tool npx      "npx -v"
call :tool claude   "claude --version"
call :tool java     "java -version"

echo.
echo === 버전 요건 ===
call :nodever
call :javaver

echo.
echo === 네트워크 ===
call :net https://github.com
call :net https://registry.npmjs.org
call :net https://claude.ai

echo.
if %FAIL%==0 (
  echo 결과: 모두 통과. 실습을 시작할 수 있습니다.
) else (
  echo 결과: 실패 %FAIL% 건. 위 [X] 항목을 해결하세요. 설치 직후라면 터미널을 새로 열고 다시 실행하세요.
)
pause
exit /b %FAIL%

:tool
where %1 > nul 2>&1
if errorlevel 1 (
  echo [X] %1  설치되지 않았거나 PATH 에 없습니다.
  set /a FAIL+=1
  exit /b 0
)
echo [OK] %1
for /f "delims=" %%v in ('%~2 2^>^&1') do (
  echo      %%v
  goto :eof
)
exit /b 0

:nodever
where node > nul 2>&1 || exit /b 0
for /f "delims=" %%v in ('node -v') do set NV=%%v
set NV=%NV:~1%
for /f "delims=." %%m in ("%NV%") do set NM=%%m
if %NM% GEQ 18 (echo [OK] Node.js %NV% ^(18 이상^)) else (echo [X] Node.js %NV% - 18 이상이 필요합니다. & set /a FAIL+=1)
exit /b 0

:javaver
where java > nul 2>&1 || exit /b 0
for /f "tokens=3" %%v in ('java -version 2^>^&1 ^| findstr /i "version"') do set JV=%%~v
for /f "delims=." %%m in ("%JV%") do set JM=%%m
if %JM% GEQ 21 (echo [OK] Java %JV% ^(21 이상^)) else (echo [X] Java %JV% - 21 이상이 필요합니다. & set /a FAIL+=1)
exit /b 0

:net
curl.exe -s -o nul -m 8 -I %1
if errorlevel 1 (
  echo [X] %1  접속 실패 - 사내망/프록시에서 막혀 있을 수 있습니다.
  set /a FAIL+=1
) else (
  echo [OK] %1
)
exit /b 0
