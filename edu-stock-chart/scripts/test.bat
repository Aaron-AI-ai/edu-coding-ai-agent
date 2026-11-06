@echo off
chcp 65001 > nul
rem 단위 테스트 전체 실행
pushd "%~dp0.."
echo [edu-stock-chart] 전체 테스트를 실행합니다.
rem gradlew.bat 대신 gradlew.ps1 (gradlew.bat 액세스 거부 대비)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0gradlew.ps1" test
echo.
echo 테스트 리포트: build\reports\tests\test\index.html
popd
