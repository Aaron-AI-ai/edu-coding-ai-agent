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

`src/main.js` 는 **더미 데이터로 차트가 뜨는 것까지만** 구현되어 있습니다.
실제 시세 조회와 화면 구성은 실습에서 만듭니다.
