# 전체 실행 스크립트

API 서버(`edu-stock-chart`)와 UI(`edu-stock-chart-ui`)를 한 번에 다룹니다.

| 스크립트 | 하는 일 | Windows | macOS · Linux |
|---|---|---|---|
| start | 새로 빌드 → 두 서비스를 백그라운드로 실행 | `scripts\start.bat` | `./scripts/start.sh` |
| status | 실행 상태 확인 | `scripts\status.bat` | `./scripts/status.sh` |
| stop | 두 서비스 중지 | `scripts\stop.bat` | `./scripts/stop.sh` |

- 대시보드 http://localhost:5173 · Swagger http://localhost:8080/swagger-ui.html
- start 는 테스트를 돌리지 않습니다. 테스트는 `edu-stock-chart/scripts/test.*`
- PID 와 로그는 `.run/` 에 남습니다 (`api.log` · `ui.log`)
- 8080 · 5173 을 이미 쓰고 있으면 start 가 멈춥니다. 개발 서버(`dev.*` · `run.*`)를 먼저 끄세요
