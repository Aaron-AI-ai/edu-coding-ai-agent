@echo off
chcp 65001 > nul
rem 빌드 결과 미리보기 - http://localhost:4173
pushd "%~dp0.."
echo [edu-stock-chart-ui] 빌드 결과를 미리봅니다. 종료하려면 Ctrl+C
call npm run preview
popd
