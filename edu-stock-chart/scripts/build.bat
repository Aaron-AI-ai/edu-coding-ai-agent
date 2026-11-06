@echo off
chcp 65001 > nul
rem 빌드 + 테스트
pushd "%~dp0.."
echo [edu-stock-chart] 빌드와 테스트를 실행합니다.
rem gradlew.bat 대신 gradlew.ps1 (gradlew.bat 액세스 거부 대비)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0gradlew.ps1" build
echo.
echo 산출물: build\libs\
popd
