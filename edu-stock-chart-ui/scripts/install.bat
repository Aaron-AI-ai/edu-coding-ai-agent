@echo off
chcp 65001 > nul
rem 의존성 설치
pushd "%~dp0.."
echo [edu-stock-chart-ui] 의존성을 설치합니다.
call npm install
popd
