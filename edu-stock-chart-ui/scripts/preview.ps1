# 빌드 결과 미리보기 - http://localhost:4173
Push-Location (Join-Path $PSScriptRoot '..')
try {
  Write-Host '[edu-stock-chart-ui] 빌드 결과를 미리봅니다. 종료하려면 Ctrl+C'
  npm run preview
} finally { Pop-Location }
