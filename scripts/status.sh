#!/usr/bin/env bash
# API 서버 · UI 실행 상태 - macOS · Linux
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RUN="$ROOT/.run"

port_open() { (exec 3<>"/dev/tcp/127.0.0.1/$1") 2>/dev/null; }

show() {  # 이름 pid파일 포트 URL
  local pid=""
  [ -f "$RUN/$2.pid" ] && pid="$(cat "$RUN/$2.pid")"
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    if port_open "$3"; then echo "[OK] $1 실행 중 (pid $pid) $4"
    else echo "[..] $1 기동 중 (pid $pid · 포트 $3 대기)"; fi
  elif port_open "$3"; then
    echo "[!]  $1 포트 $3 을 다른 프로세스가 쓰고 있습니다 (이 스크립트로 띄운 것이 아님)"
  else
    echo "[--] $1 중지됨"
  fi
}

show "API 서버" api 8080 http://localhost:8080/swagger-ui.html
show "UI      " ui  5173 http://localhost:5173
