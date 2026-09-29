#!/usr/bin/env bash
# 배포 빌드 - dist/
set -e
cd "$(dirname "$0")/.."
echo "[edu-stock-chart-ui] 배포 빌드를 실행합니다."
npm run build
echo
echo "결과물: dist/"
