# 배포 빌드 - dist/
Push-Location (Join-Path $PSScriptRoot '..')
try {
  Write-Host '[edu-stock-chart-ui] 배포 빌드를 실행합니다.'
  npm run build
  Write-Host ''
  Write-Host '결과물: dist\'
} finally { Pop-Location }
