#!/usr/bin/env bash
# 빌드 + 테스트
set -e
cd "$(dirname "$0")/.."
echo "[edu-stock-chart] 빌드와 테스트를 실행합니다."
./gradlew build
echo
echo "산출물: build/libs/"
