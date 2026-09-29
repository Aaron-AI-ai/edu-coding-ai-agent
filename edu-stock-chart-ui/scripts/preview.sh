#!/usr/bin/env bash
# 빌드 결과 미리보기 - http://localhost:4173
set -e
cd "$(dirname "$0")/.."
echo "[edu-stock-chart-ui] 빌드 결과를 미리봅니다. 종료하려면 Ctrl+C"
npm run preview
