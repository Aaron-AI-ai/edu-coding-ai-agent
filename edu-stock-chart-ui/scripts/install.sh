#!/usr/bin/env bash
# 의존성 설치
set -e
cd "$(dirname "$0")/.."
echo "[edu-stock-chart-ui] 의존성을 설치합니다."
npm install
