#!/usr/bin/env bash
# Swagger UI 열기 - 서비스가 실행 중이어야 합니다
URL="http://localhost:8080/swagger-ui.html"
echo "[edu-stock-chart] Swagger UI를 엽니다. ($URL)"
echo "  서비스가 꺼져 있으면 scripts/run.sh 를 먼저 실행하세요."
if command -v open > /dev/null; then open "$URL"; else xdg-open "$URL"; fi
