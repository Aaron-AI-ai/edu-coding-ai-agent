# setup — Windows 사전 준비

실습 전에 한 번만 실행합니다. Windows 10 (1809 이상) / 11, 인터넷 연결이 필요합니다.

| 스크립트 | 하는 일 |
|---|---|
| `install.bat` | winget 으로 Git, Node.js LTS(npm·npx 포함), JDK 21(Azul Zulu) 설치. 이미 있으면 건너뜀 |
| `verify.bat` | 도구 설치·버전(Node 18+, Java 21+)과 github.com / npm / claude.ai 접속 확인. 모두 통과하면 종료 코드 0 |

## 순서

1. `setup\install.bat` 실행 (설치 창이 뜨면 허용)
2. **터미널을 닫고 새로 연다** — PATH 가 새 터미널부터 적용됩니다
3. `setup\verify.bat` 실행 → 모든 항목이 `[OK]`

## 참고

- `claude` 는 이 스크립트가 설치하지 않습니다. 슬라이드의 설치 단계를 따르고, `verify.bat` 으로 확인합니다.
- 사내망에서 `[X] 접속 실패` 가 나오면 프록시 설정을 확인하세요.
- Windows 에서 실제로 실행해 검증하지 않았습니다. 첫 시연 전에 Windows 1대에서 시험하세요.
