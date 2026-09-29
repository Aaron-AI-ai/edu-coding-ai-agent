#!/usr/bin/env bash
# 단위 테스트 전체 실행
set -e
cd "$(dirname "$0")/.."
echo "[edu-stock-chart] 전체 테스트를 실행합니다."
./gradlew test
echo
echo "테스트 리포트: build/reports/tests/test/index.html"
