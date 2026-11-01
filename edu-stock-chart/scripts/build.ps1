# 빌드 + 테스트
Push-Location (Join-Path $PSScriptRoot '..')
try {
  Write-Host '[edu-stock-chart] 빌드와 테스트를 실행합니다.'
  & .\scripts\gradlew.ps1 build
  Write-Host ''
  Write-Host '산출물: build\libs\'
} finally { Pop-Location }
