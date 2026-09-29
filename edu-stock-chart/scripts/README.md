# 실습 스크립트

| 스크립트 | 하는 일 | Windows | macOS · Linux |
|---|---|---|---|
| run | 서비스 실행 — http://localhost:8080 | `scripts\run.bat` | `./scripts/run.sh` |
| test | 단위 테스트 전체 | `scripts\test.bat` | `./scripts/test.sh` |
| build | 빌드 + 테스트 | `scripts\build.bat` | `./scripts/build.sh` |
| swagger | Swagger UI 열기 | `scripts\swagger.bat` | `./scripts/swagger.sh` |
| h2 | H2 콘솔 열기 | `scripts\h2.bat` | `./scripts/h2.sh` |

swagger · h2 는 서비스가 실행 중이어야 합니다.

## H2 콘솔 접속 정보

| 항목 | 값 |
|---|---|
| JDBC URL | `jdbc:h2:mem:stockchart` |
| User | `sa` |
| Password | (비움) |

인메모리 DB라 서비스를 끄면 데이터가 사라집니다.

## 참고

- 테스트 리포트: `build/reports/tests/test/index.html`
- macOS에서 권한 오류가 나면 `chmod +x scripts/*.sh`
- 포트를 바꾸려면 `src/main/resources/application.yml` 에 `server.port` 추가
