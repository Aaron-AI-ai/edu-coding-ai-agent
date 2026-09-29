@echo off
chcp 65001 > nul
rem 배포 빌드 - dist/
pushd "%~dp0.."
echo [edu-stock-chart-ui] 배포 빌드를 실행합니다.
call npm run build
echo.
echo 결과물: dist\
popd
