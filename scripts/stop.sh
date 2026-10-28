#!/usr/bin/env bash
# API 서버 · UI 중지 - macOS · Linux
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RUN="$ROOT/.run"

stop() {  # 이름 pid파일
  local f="$RUN/$2.pid"
  if [ ! -f "$f" ]; then echo "[--] $1 실행 기록 없음"; return; fi
  local pid; pid="$(cat "$f")"
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid"
    for _ in $(seq 1 10); do kill -0 "$pid" 2>/dev/null || break; sleep 1; done
    kill -0 "$pid" 2>/dev/null && kill -9 "$pid"
    echo "[OK] $1 중지 (pid $pid)"
  else
    echo "[--] $1 이미 중지됨"
  fi
  rm -f "$f"
}

stop "API 서버" api
stop "UI" ui
