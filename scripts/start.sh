#!/usr/bin/env bash
# 새로 빌드한 뒤 API 서버(8080)와 UI(5173)를 백그라운드로 실행 - macOS · Linux
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RUN="$ROOT/.run"
API="$ROOT/edu-stock-chart"
UI="$ROOT/edu-stock-chart-ui"
mkdir -p "$RUN"

port_open() { (exec 3<>"/dev/tcp/127.0.0.1/$1") 2>/dev/null; }

for port in 8080 5173; do
  if port_open "$port"; then
    echo "[X] 포트 $port 를 이미 쓰고 있습니다. 먼저 scripts/stop.sh 를 실행하세요"
    exit 1
  fi
done

echo "[1/4] API 서버 빌드 (테스트 제외 · 테스트는 edu-stock-chart/scripts/test.sh)"
(cd "$API" && ./gradlew clean bootJar -q)
JAR="$(ls "$API"/build/libs/*.jar | grep -v plain | head -1)"

echo "[2/4] UI 빌드"
(cd "$UI" && { [ -d node_modules ] || npm install; } && npm run build --silent)

echo "[3/4] 실행"
nohup java -jar "$JAR" > "$RUN/api.log" 2>&1 &
echo $! > "$RUN/api.pid"
# 서브셸 없이 띄워야 $! 가 node 의 pid 가 된다
cd "$UI"
nohup node node_modules/vite/bin/vite.js preview --host 127.0.0.1 --port 5173 --strictPort > "$RUN/ui.log" 2>&1 &
echo $! > "$RUN/ui.pid"
cd "$ROOT"

echo "[4/4] 기동 대기 (최대 60초)"
for _ in $(seq 1 60); do
  if curl -sf http://localhost:8080/api/dashboard/indices > /dev/null && port_open 5173; then
    echo
    echo "[OK] 실행 완료"
    echo "  대시보드  http://localhost:5173"
    echo "  Swagger   http://localhost:8080/swagger-ui.html"
    echo "  로그      .run/api.log · .run/ui.log"
    exit 0
  fi
  sleep 1
done
echo "[X] 60초 안에 뜨지 않았습니다. .run/api.log · .run/ui.log 를 확인하세요"
exit 1
