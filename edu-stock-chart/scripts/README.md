# 실습 스크립트

| 스크립트 | 하는 일 | Windows (cmd) | Windows (PowerShell) | macOS · Linux |
|---|---|---|---|---|
| run | 서비스 실행 — http://localhost:8080 | `scripts\run.bat` | `scripts\run.ps1` | `./scripts/run.sh` |
| test | 단위 테스트 전체 | `scripts\test.bat` | `scripts\test.ps1` | `./scripts/test.sh` |
| build | 빌드 + 테스트 | `scripts\build.bat` | `scripts\build.ps1` | `./scripts/build.sh` |
| swagger | Swagger UI 열기 | `scripts\swagger.bat` | `scripts\swagger.ps1` | `./scripts/swagger.sh` |
| h2 | H2 콘솔 열기 | `scripts\h2.bat` | `scripts\h2.ps1` | `./scripts/h2.sh` |

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
- PowerShell 에서 실행이 막히면 `powershell -ExecutionPolicy Bypass -File scripts\run.ps1` 처럼 실행
- PowerShell 스크립트는 `gradlew.bat` 대신 `scripts\gradlew.ps1` 로 Gradle 을 실행한다 — `.bat` 실행이 「액세스 거부」로 막힌 PC 대비
