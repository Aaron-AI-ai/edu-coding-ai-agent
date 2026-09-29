# UI 실습 스크립트

| 스크립트 | 하는 일 | Windows | macOS · Linux |
|---|---|---|---|
| install | 의존성 설치 (최초 1회) | `scripts\install.bat` | `./scripts/install.sh` |
| dev | 개발 서버 — http://localhost:5173 | `scripts\dev.bat` | `./scripts/dev.sh` |
| build | 배포 빌드 — `dist/` | `scripts\build.bat` | `./scripts/build.sh` |
| preview | 빌드 결과 미리보기 — http://localhost:4173 | `scripts\preview.bat` | `./scripts/preview.sh` |

`dev` 는 `node_modules` 가 없으면 의존성을 먼저 설치합니다.

## API 연동

`/api` 요청은 `http://localhost:8080`(Spring Boot)으로 프록시됩니다.
백엔드(`edu-stock-chart`)를 먼저 실행한 뒤 UI를 띄우세요.

## 참고

- macOS에서 권한 오류가 나면 `chmod +x scripts/*.sh`
