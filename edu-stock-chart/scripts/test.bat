@echo off
chcp 65001 > nul
rem 단위 테스트 전체 실행
pushd "%~dp0.."
echo [edu-stock-chart] 전체 테스트를 실행합니다.
call gradlew.bat test
echo.
echo 테스트 리포트: build\reports\tests\test\index.html
popd
