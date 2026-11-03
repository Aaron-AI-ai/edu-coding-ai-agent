# install — Windows 교육 환경 준비

Windows 10 (1809 이상) / 11 · PowerShell 5.1 이상 · winget(앱 설치 관리자)이 기준입니다.
도구 목록은 `tools.psd1` 한 곳에 있고, 네 스크립트가 모두 이 목록을 읽습니다.

## 순서

| 순서 | 실행 | 하는 일 |
|---|---|---|
| 1 | `1-check.bat` | 도구 설치 · 버전 표, **충돌 점검 → 번호를 골라 삭제 · 종료**, 접속 확인 |
| 2 | `2-download.bat` *(선택)* | 설치 파일을 `install\packages\` 에 미리 받기 — 인터넷이 느리거나 막힌 교실용 |
| 3 | `3-install.bat` | **없거나 버전이 낮은 것만** 골라 설치 → 실습 프로젝트 의존성(Gradle · npm) 미리 받기 |
| — | 터미널을 모두 닫고 새로 연다 | PATH 반영 · `claude` 를 한 번 실행해 로그인 |
| 4 | `4-claude-setup.bat` | 강의에서 쓰는 플러그인 · Skill 중 **없는 것만** 골라 설치 |
| 5 | `1-check.bat` | 다시 점검 — 필수 항목이 모두 `[OK]` 면 종료 코드 0 |

`.ps1` 을 직접 실행해도 됩니다 (탐색기에서 오른쪽 클릭 → 「PowerShell에서 실행」 또는 `powershell -ExecutionPolicy Bypass -File install\check.ps1`). 새로 뜬 창은 결과를 보여 준 뒤 **엔터를 칠 때까지 기다립니다**. 이미 열어 둔 터미널에서 `.\install\check.ps1` 로 실행하면 기다리지 않습니다 (항상 바로 끝내려면 `$env:EDU_INSTALL_NOPAUSE=1`). ZIP 으로 받아 「스크립트를 실행할 수 없습니다」가 나오면 PowerShell 에서 `Get-ChildItem install -Recurse | Unblock-File` 을 한 번 실행합니다.

옵션은 `.bat` 뒤에 붙입니다: `3-install.bat -Yes` (묻지 않음) · `-RequiredOnly` (필수만) · `-Offline` (받아 둔 파일만) · `-SkipWarmup` · `1-check.bat -ReportOnly` (보고만) · `2-download.bat -Only git,node,java`

## 설치하는 것

| 구분 | 도구 | 왜 필요한가 | winget ID |
|---|---|---|---|
| 필수 | Git for Windows 2.40+ | Claude Code 가 Git Bash 를 쓴다 · clone · worktree | `Git.Git` |
| 필수 | Node.js LTS 22+ (npm · npx) | edu-stock-chart-ui (Vite) · `npx skills` · Playwright MCP · HyperFrames | `OpenJS.NodeJS.LTS` |
| 필수 | JDK **21** (Azul Zulu) | edu-stock-chart — Spring Boot 3.4 · Gradle 8.6 · toolchain 21 | `Azul.Zulu.21.JDK` |
| 필수 | Claude Code 2.1.223+ | 과정 전체 · `/code-review` | `Anthropic.ClaudeCode` (안 되면 `irm https://claude.ai/install.ps1 \| iex`) |
| 권장 | Python 3.12 · uv | graphify (`uv tool install graphifyy`) · obsidian-second-brain | `Python.Python.3.12` · `astral-sh.uv` |
| 권장 | FFmpeg | HyperFrames 영상 렌더 | `Gyan.FFmpeg` |
| 권장 | Google Chrome | Playwright MCP 화면 검증 · Hallmark 화면 검사 | `Google.Chrome` |
| 권장 | Obsidian | LLM 위키 실습 | `Obsidian.Obsidian` |
| 권장 | Orca | 에이전트를 워크트리별 탭으로 병렬 실행 | `StablyAI.Orca` (안 되면 GitHub 릴리스) |

설치 순서: **winget → `packages\` 의 받아 둔 파일(무인 옵션) → 공식 설치 스크립트**. JDK 21 을 설치하면 `JAVA_HOME` 이 비었거나 21 이 아닐 때 21 로 맞춥니다.

## 충돌 점검 (1-check.bat)

| 충돌 | 왜 문제인가 | 고르면 하는 일 |
|---|---|---|
| 21 이 아닌 JDK 가 PATH 앞 · `JAVA_HOME` 이 다른 JDK | Gradle 8.6 · toolchain 21 빌드가 깨진다 | 다른 JDK `winget uninstall` · 잘못된 `JAVA_HOME` 비우기 |
| Node 22 미만 · node 가 여러 곳 · nvm-windows 와 설치본 공존 | HyperFrames · Playwright 가 안 돈다 · 버전이 엇갈린다 | 오래된 Node `winget uninstall` (3단계에서 LTS 재설치) |
| npm 전역 claude 와 네이티브 claude 공존 | 어느 claude 가 도는지 모른다 · 업데이트가 엇갈린다 | `npm uninstall -g @anthropic-ai/claude-code` |
| python 이 Microsoft Store 바로가기 | python 을 치면 설치 창만 뜬다 | 안내만 (설정 > 앱 실행 별칭에서 끈다) |
| 8080 · 5173 포트를 다른 프로그램이 사용 | `scripts\start.bat` 이 멈춘다 | 해당 프로세스 종료 |

자동으로 고칠 수 없는 항목은 「직접 확인」으로 안내만 하고, 고칠 수 있는 항목은 번호를 고른 뒤 항목마다 한 번 더 `y` 로 확인합니다.

## 플러그인 · Skill (4-claude-setup.bat)

- 마켓: `claude-plugins-official` · `hyperframes` · `ponytail` · `thedotmack` · `obsidian-second-brain`
- 플러그인: superpowers · playwright · context7 · skill-creator · hyperframes · ponytail · claude-mem · obsidian-second-brain
- Skill: archify · drawio-skill · hallmark (`npx skills add … -g`) · eli5 (git 없이 `eli5-pack\eli5.zip` 압축 해제 → `~\.claude\skills\eli5`) · graphify (`uv tool install graphifyy` → `graphify install`)

서드파티 플러그인은 훅과 MCP 서버를 실행할 수 있습니다. 목록을 보고 필요한 번호만 골라 설치하세요.

## 참고

- `packages\` 는 git 에 올리지 않습니다 (`.gitignore`). `install` 폴더를 통째로 복사해 가면 교육 PC 에서 받은 파일로 설치합니다.
- 사내망에서 접속 실패가 나오면 프록시 (`HTTPS_PROXY` · npm `proxy` · winget 프록시 설정)를 확인하세요.
- `setup\` 의 기존 스크립트(Git · Node · JDK 만)는 그대로 둡니다. 새 교육 환경은 이 `install\` 을 씁니다.
- **Windows 에서 아직 실제로 실행해 보지 않았습니다.** 첫 교육 전에 깨끗한 Windows 1대에서 1 → 3 → 4 → 1 순서로 시험하세요.
