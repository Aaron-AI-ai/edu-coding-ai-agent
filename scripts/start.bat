@echo off
chcp 65001 > nul
rem 새로 빌드한 뒤 API 서버(8080)와 UI(5173)를 백그라운드로 실행 - Windows
setlocal
set "ROOT=%~dp0.."
set "RUN=%ROOT%\.run"
if not exist "%RUN%" mkdir "%RUN%"

for %%P in (8080 5173) do (
  netstat -ano | findstr /r /c:":%%P .*LISTENING" > nul && (
    echo [X] 포트 %%P 를 이미 쓰고 있습니다. 먼저 scripts\stop.bat 을 실행하세요
    exit /b 1
  )
)

echo [1/4] API 서버 빌드 (테스트 제외 · 테스트는 edu-stock-chart\scripts\test.bat)
pushd "%ROOT%\edu-stock-chart"
call gradlew.bat clean bootJar -q || (popd & exit /b 1)
for %%J in (build\libs\*.jar) do (
  echo %%~nJ | findstr plain > nul || set "JAR=%%J"
)
popd

echo [2/4] UI 빌드
pushd "%ROOT%\edu-stock-chart-ui"
if not exist node_modules call npm install || (popd & exit /b 1)
call npm run build --silent || (popd & exit /b 1)
popd

echo [3/4] 실행
powershell -NoProfile -Command "$p = Start-Process java -ArgumentList '-jar','%JAR%' -WorkingDirectory '%ROOT%\edu-stock-chart' -RedirectStandardOutput '%RUN%\api.log' -RedirectStandardError '%RUN%\api.err.log' -WindowStyle Hidden -PassThru; $p.Id | Out-File -Encoding ascii '%RUN%\api.pid'"
powershell -NoProfile -Command "$p = Start-Process node -ArgumentList 'node_modules\vite\bin\vite.js','preview','--host','127.0.0.1','--port','5173','--strictPort' -WorkingDirectory '%ROOT%\edu-stock-chart-ui' -RedirectStandardOutput '%RUN%\ui.log' -RedirectStandardError '%RUN%\ui.err.log' -WindowStyle Hidden -PassThru; $p.Id | Out-File -Encoding ascii '%RUN%\ui.pid'"

echo [4/4] 기동 대기 (최대 60초)
for /l %%i in (1,1,60) do (
  curl -sf http://localhost:8080/api/dashboard/indices > nul 2>&1 && curl -s -o nul http://localhost:5173 && goto ready
  ping -n 2 127.0.0.1 > nul
)
echo [X] 60초 안에 뜨지 않았습니다. .run\api.log · .run\ui.log 를 확인하세요
exit /b 1

:ready
echo.
echo [OK] 실행 완료
echo   대시보드  http://localhost:5173
echo   Swagger   http://localhost:8080/swagger-ui.html
echo   로그      .run\api.log · .run\ui.log
