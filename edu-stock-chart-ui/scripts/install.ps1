# 의존성 설치
Push-Location (Join-Path $PSScriptRoot '..')
try {
  Write-Host '[edu-stock-chart-ui] 의존성을 설치합니다.'
  npm install
} finally { Pop-Location }
