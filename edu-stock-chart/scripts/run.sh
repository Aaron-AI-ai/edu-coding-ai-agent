#!/usr/bin/env bash
# 서비스 실행 - http://localhost:8080
set -e
cd "$(dirname "$0")/.."
echo "[edu-stock-chart] 서비스를 시작합니다. 종료하려면 Ctrl+C"
echo "  Swagger  http://localhost:8080/swagger-ui.html"
echo "  H2       http://localhost:8080/h2-console"
echo
./gradlew bootRun
