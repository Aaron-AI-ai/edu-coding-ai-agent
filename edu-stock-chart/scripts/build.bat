@echo off
chcp 65001 > nul
rem 빌드 + 테스트
pushd "%~dp0.."
echo [edu-stock-chart] 빌드와 테스트를 실행합니다.
call gradlew.bat build
echo.
echo 산출물: build\libs\
popd
