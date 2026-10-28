# edu-stock-chart-ui

주식 차트 실습의 웹 UI 프로젝트입니다. Vite + Chart.js 로 구성했습니다.

## 구성

| 항목 | 내용 |
|---|---|
| 빌드 도구 | Vite 6 |
| 차트 | Chart.js 4 |
| 프레임워크 | 없음 (vanilla JS) |
| API 프록시 | `/api` → `http://localhost:8080` (Spring Boot) |

프레임워크를 쓰지 않습니다. 실습의 초점이 화면 기술이 아니라 **에이전트로 만드는 과정**이기 때문입니다.

## 실행 (Windows)

```
scripts\install.bat    의존성 설치 (최초 1회)
scripts\dev.bat        개발 서버 - http://localhost:5173
scripts\build.bat      배포 빌드 - dist/
```

macOS · Linux 는 `scripts/*.sh` 를 사용합니다.

## API 연동

`vite.config.js` 에 프록시가 걸려 있어 `/api` 로 호출하면 Spring Boot(8080)로 전달됩니다.

```js
const res = await fetch('/api/stocks/005930/prices?from=2026-01-01&to=2026-06-30');
```

백엔드(`edu-stock-chart`)를 먼저 실행한 뒤 UI를 띄우세요.

## 현재 상태

코스콤증권 홈 대시보드 화면이 구현되어 있습니다. 데이터는 백엔드 H2 시드(`data.sql`)에서 옵니다.

| 영역 | API |
|---|---|
| 지수 카드 · 하단 티커 | `GET /api/dashboard/indices` |
| 주요 일정 | `GET /api/dashboard/schedules` |
| 실시간 차트 순위 | `GET /api/dashboard/rankings` |

버튼은 눌린 상태만 바뀌고 화면 전환은 하지 않습니다. 단, M9 루프 실습 과제 두 곳은 화면이 먼저 연결되어 있고 서버 구현을 기다립니다.

| 화면 | 호출 | 과제 |
|---|---|---|
| 순위 필터 · 정렬 버튼 | `GET /api/dashboard/rankings?market=&sort=` | `docs/practice/m9-ranking-filter.md` |
| 상단 검색창 | `GET /api/stocks/search?q=` | `docs/practice/m9-stock-search.md` |
