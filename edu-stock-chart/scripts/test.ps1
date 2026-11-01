# 단위 테스트 전체 실행
Push-Location (Join-Path $PSScriptRoot '..')
try {
  Write-Host '[edu-stock-chart] 전체 테스트를 실행합니다.'
  .\gradlew.bat test
  Write-Host ''
  Write-Host '테스트 리포트: build\reports\tests\test\index.html'
} finally { Pop-Location }
