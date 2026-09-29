#!/usr/bin/env bash
# H2 콘솔 열기 - 서비스가 실행 중이어야 합니다
URL="http://localhost:8080/h2-console"
echo "[edu-stock-chart] H2 콘솔을 엽니다. ($URL)"
echo "  JDBC URL : jdbc:h2:mem:stockchart"
echo "  User     : sa"
echo "  Password : (비움)"
if command -v open > /dev/null; then open "$URL"; else xdg-open "$URL"; fi
