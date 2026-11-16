# AI Agent와 함께 만드는 미니 금융 시스템 — 2일 과정 커리큘럼

## 🚀 AI Agent와 함께, 자바로 미니 금융 시스템 만들어보기

**코드 한 줄 직접 타이핑하지 않고 서비스 하나를 완성합니다.**

이제 개발자의 일은 키보드로 코드를 치는 것이 아니라, **AI에게 규칙을 주고 결과를 검증하는 것**입니다.
이 과정은 그 전환을 2일 동안 손으로 경험하게 합니다.

- **개념부터** — 코딩 모델과 벤치마크, 하네스, 루프와 그래프 엔지니어링이란 무엇인가
- **트렌드까지** — AI-SDLC, CLAUDE.md·스킬·훅·MCP·플러그인 등 최신 AI Agent 개발 방식
- **그리고 결과물** — 실제로 돌아가는 주식 차트 웹 서비스와, 나만의 개발 루프

> *같은 도구, 다른 결과 — 84%의 개발자가 AI를 쓰지만 결과는 3배 넘게 벌어집니다. 차이는 하네스와 루프에서 납니다.*

## 1. 과정 개요

| 항목 | 내용 |
|---|---|
| 기간 | 2일 (1일 7시간, 총 14시간) |
| 인원 | 15명, 1인 1 Team 계정 |
| 대상 | Java/Spring Boot, Git 경험이 있는 개발자 |
| 실습 스택 | Java 21, Spring Boot 3.4, Gradle 8.6, **MyBatis + H2**, Lombok, springdoc(Swagger UI), JUnit 5, PMD · 화면 `edu-stock-chart-ui`(Vite 6 + Chart.js 4) |
| 실습 과제 | **미니 금융 시스템 — 주식 차트 웹 서비스** (`edu-stock-chart` API + `edu-stock-chart-ui` 대시보드) |
| 목표 | **AI Agent 기반 개발의 기본 개념을 이해하고, 토이 프로젝트(미니 금융 시스템) 실습을 통해 직접 활용하며 몸에 익힌다** |
| 비율 | 이론 30% · 강사 데모 20% · 실습 50% |
| 산출물 | 동작하는 API·화면 + 수강생별 `.claude/` 설정(CLAUDE.md, 스킬, 훅) + 코드 위키·그래프 · 시퀀스 다이어그램 + 코드 리뷰 결과 |

### 학습 목표

**A. AI Agent 기반 개발의 기본 개념을 이해한다**

1. 코딩 모델의 동향과 벤치마크가 무엇을 재는지 알고, 작업에 맞는 모델을 고를 수 있다.
2. 하네스·루프 엔지니어링·그래프 엔지니어링의 개념을 알고 그 동작 원리를 설명할 수 있다.
3. AI-SDLC의 각 단계에서 **사람이 무엇을 책임지는지**(게이트) 구분할 수 있다.

**B. 토이 프로젝트로 직접 실습하며 몸에 익힌다**

4. Claude Code로 **개발 하네스**(CLAUDE.md·스킬·훅·MCP·플러그인)를 구성한다.
5. 팀 규칙(Controller → Service → Mapper, RESTful, Swagger 설명, 생성자 주입, `BigDecimal`)을 **CLAUDE.md·스킬·훅**으로 만들어 AI가 지키게 한다.
6. `/goal` 루프로 **명세 → 구현 → 테스트 → 화면 검증**을 사람 개입 없이 돌리고, 별도 세션 `/code-review`로 검증한다.

### 실습 프로젝트: 주식 차트 웹 서비스

| 구성 | 내용 |
|---|---|
| API (`edu-stock-chart`) | 대시보드(`/api/dashboard/indices` · `/schedules` · `/rankings`), 종가 이동평균(`/api/stocks/{symbol}/moving-average`) · 패키지 `kr.co.koscom.edu.stockchart` |
| 화면 (`edu-stock-chart-ui`) | 대시보드 한 페이지 — 지수 · 경제 일정 · 순위 표 · 검색창 · 종목 상세(미구현 API를 부르도록 미리 연결) |
| 데이터 | `schema.sql` · `data.sql` · `data-detail.sql` 시드를 H2에 적재 — 수업 중 외부 API 호출 없음 |
| 실행 | `scripts/start.ps1`(Windows) · `start.sh`(macOS/Linux) → API 8080 · 화면 5173 · Swagger `localhost:8080/swagger-ui.html` · `stop` · `status` |
| 일부러 넣어 둔 것 | 과잉 설계된 `MovingAverageService`(ponytail 실습) · `fetchWithRetry` 재시도(시퀀스 다이어그램 실습) · PMD 규칙 5개(Hook 실습) |

#### 시드 데이터 (준비됨)

| 테이블 | 규모 · 용도 |
|---|---|
| `stock_ranking` | 17개 (국내 7 · 해외 10) · `rank_no` · `overseas` · `change_rate` — M9 과제 1 |
| `stock` | 32개 (국내 20 · 해외 12) · `symbol` · `name` · `market` — M9 과제 2 |
| `account` | 3건 (예: `110-1234-5678` 홍길동 1,500,000) — M5 계좌 잔고 조회 |
| `market_index` · `economic_schedule` · `stock_price` | 대시보드 · 이동평균 |
| `stock_quote` · `stock_daily_price` | 종목 상세(SOXL 등) — M11 시연 |

- 코스모스바이오 · 한빛테크 · 그린마스 홀딩스는 **가상의 종목**이다.
- 실제 시세로 바꿀 경우: KRX 데이터는 비상업적 목적만 허용 · 제3자 제공 금지 · "한국거래소 통계정보" 출처 표시 필수 → 공개 레포 커밋 금지, 수정주가 미적용이므로 액면분할 이력이 없는 종목을 고른다.

---

## 2. 실행 환경·사용량 운영 원칙 (Team 계정)

수강생은 **회사 Team 계정으로 실습**한다. 배우는 대상(Claude Code + Claude 모델)을 그대로 쓰는 것이 교육 효과와 안정성 모두에서 낫고, 교육 후 업무 환경과도 같다.

### 2.1 모델 구성

| 용도 | 모델 | 비고 |
|---|---|---|
| 수강생 실습 전체 | **Sonnet 5.5** | `/model sonnet` · 일상 코딩·반복 작업에 가장 효율적. 기본값으로 고정 |
| 서브에이전트 · 단순 작업 | **Haiku 5.5** | 로그 요약·대량 처리, 한도 절약 |
| 별도 세션 코드 리뷰 (M10) | **Opus 5.5** | `/model claude-opus-5-5` → `/code-review` → 끝나면 `/model claude-sonnet-5-5` 로 되돌린다 |
| context7 비교 실습 (M3) | Sonnet 4.6 | 지식 기준 2025.08 — Spring Boot 4를 모르는 모델로 MCP 유무를 비교 |
| 강사 시연 (M11) | **Opus 5.5** | 강사 계정으로만 실행. 전원이 쓰면 공용 풀이 빠르게 소진됨 |

### 2.2 5시간 사용 한도 대응 — "윈도우 설계"

Team 사용량은 **첫 메시지를 보낸 시점부터 5시간 단위**로 집계되고, 여기에 주간 한도가 별도로 걸린다. 하루 수업(7시간)은 두 윈도우에 걸치므로, **토큰을 많이 쓰는 실습이 한 윈도우에 몰리지 않도록** 시간표를 짰다.

| | 윈도우 A | 윈도우 B |
|---|---|---|
| Day 1 | 10:40(M2 첫 프롬프트) ~ 15:40 — M2 🟢 · M3 🟡 · M4 🟢 · M5 🟡 | 15:40 ~ — M6 🟡 |
| Day 2 | 10:10(M8 첫 실습) ~ 15:10 — M8 🟡 · M9 🟡 · M10 리뷰 실습 🟡 (M11은 강사만) | 15:10 ~ — M12 🟢 |

- 오전 이론 시간(Day 1 09:00–10:40, Day 2 09:00–10:10)에는 **Claude에 프롬프트를 보내지 않는다** → 윈도우 시작을 실습 시점으로 늦춘다. `/model` · `/permissions` · `/context`는 모델을 호출하지 않으므로 써도 된다.
- **claude-mem `/learn-codebase`(약 5분 · 토큰 소모 큼)와 obsidian `architect` 전체 생성은 한 번만** — 이후는 증분 갱신.
- **수업 전·점심시간 개인 사용 금지** — 웹·데스크톱·모바일이 **Claude Code와 같은 풀**을 쓴다.
- 주간 한도도 있으므로 **교육 전날 과도한 사용 자제** 안내.

### 2.3 한도 안전판 — 사용 크레딧 (강사 사전 작업)

- **좌석 유형 확인**: Standard는 Pro의 약 1.25배, Premium은 그 5배. 관리자 콘솔에서 확인하고, Premium이면 한도 우려는 사실상 해소된다.
- **Standard라면 교육 기간 한정으로 사용 크레딧(usage credits)을 활성화**한다. 한도에 도달한 수강생이 **환경을 바꾸지 않고** 계속 작업할 수 있고, 초과분만 과금된다. 1인당 상한을 함께 건다.
- `/code-review ultra`는 클라우드에서 돌고 별도 과금된다 → 실습에서는 쓰지 않는다.

### 2.4 리허설로 실측 (필수)

Anthropic은 고정 수치를 공표하지 않는다. 실제 소모량은 대화 길이와 읽는 파일 양에 좌우되므로 **추정하지 말고 측정한다.**

- 교육 전 강사가 **Day 1·2 전체 실습을 Standard 좌석으로 완주**하며 모듈마다 `/usage` 기록.
- 특히 측정할 것: claude-mem `/learn-codebase`, obsidian `architect`, M9 `/goal`(재시도 15회 상한), Playwright 화면 점검, M11 시연 사이클.
- 반나절에 한도의 30% 수준이면 여유, 70%를 넘으면 실습 분량 조정 또는 크레딧 상한 상향.

### 2.5 수강생 공통 규칙 (Day 1 첫 시간에 배포)

비용뿐 아니라 **결과 품질**을 위해 지킨다.

- **모델**: 기본 `Sonnet 5.5`. Opus 5.5는 M10 리뷰 세션에서만 쓰고 바로 되돌린다.
- **컨텍스트**: 주제가 바뀌면 `/clear`, 길어지면 `/compact`. `/context`로 점유율 확인. 기록 없이 물을 땐 `/btw`.
- **탐색 최소화**: "프로젝트 전체 분석해줘" 금지 → `@src/main/java/.../MovingAverageService.java`처럼 직접 지정.
- **Plan 먼저**: `Shift+Tab`으로 Plan 모드 — 잘못 구현한 걸 되돌리는 비용이 계획 검토 비용보다 크다. 멈출 땐 `Esc`, 되돌릴 땐 `Esc Esc`(`/rewind`).
- **MCP·플러그인은 필요한 것만 켜기**: 도구 정의 자체가 컨텍스트를 차지한다. 실습이 끝나면 `/mcp`에서 끈다.
- **사용량 확인**: 모듈이 끝날 때마다 `/usage` 확인.

### 2.6 실습 토큰 등급

| 등급 | 의미 | 운영 방식 |
|---|---|---|
| 🟢 Low | 짧은 대화, 파일 1~3개 | 전원 실습 |
| 🟡 Mid | Plan → 구현 → 테스트 1사이클, `/goal` 루프 | 전원 실습, Sonnet 5.5 |
| 🔴 High | 멀티 에이전트, 대규모 탐색, 병렬 작업 | **강사 데모만** |

### 2.7 Java/Spring Boot 특화 절감 포인트

Java는 코드가 길고 Gradle 출력이 장황해 **같은 작업도 토큰을 더 쓴다.** 다음을 실습 프로젝트에 미리 반영했다.

- **빌드 출력 줄이기**: Stop 훅은 `./gradlew test pmdMain build -q 1>&2 || exit 2` — 느리면 `compileJava pmdMain`만.
- **의존성 사전 다운로드**: `install/3-install.bat`이 Gradle · npm 의존성을 미리 받는다(warmup).
- **보일러플레이트는 미리 제공**: 도메인 · Mapper · 시드 데이터 · 화면은 커밋해 두고, 실습은 API · 테스트에 집중.
- **화면은 미리 빌드·연결**: 버튼 · 검색창 · 상세 클릭이 이미 API를 부른다 → 수강생은 Spring Boot API만 구현.
- **Java LSP 플러그인(jdtls-lsp)**: 심볼 탐색을 grep·전체 파일 읽기 대신 LSP로. 코드 관계는 graphify(로컬 tree-sitter 분석, 무료)로.

---

## 3. Day 1 — 하네스 구성과 첫 기능 개발

**하루의 목표: 나의 하네스(CLAUDE.md · 스킬 · MCP · 훅)를 갖추고, 그 하네스로 API를 만든다.** 진행 순서는 에이전틱 코딩 덱의 장 순서를 그대로 따른다.

| 시간 | 세션 | 형식 | 토큰 | 자료 |
|---|---|---|---|---|
| 09:00–09:20 | 오리엔테이션, 환경 점검(`install/1-check.bat`) | 안내 | – (프롬프트 금지) | `install/` · `docs/00-intro/pre-survey.md` |
| 09:20–10:00 | **M1. 코딩 모델 동향과 벤치마크** | 이론 | – | 인트로 1–6장 |
| 10:10–11:00 | **M2. 에이전틱 코딩과 하네스 — Claude Code 시작하기** ← 윈도우 A 시작 | 이론+실습 | 🟢 | 1–10장 |
| 11:00–12:00 | **M3. 플러그인** | 실습 | 🟡 | 11–21장 |
| 12:00–13:00 | 점심 | | | |
| 13:00–14:00 | **M4. CLAUDE.md와 Skill 개념** | 이론+실습 | 🟢 | 22–31장 |
| 14:00–15:20 | **M5. Skill로 API 개발** | 실습 | 🟡 | 32–34장 |
| 15:30–17:10 | **M6. MCP와 Hook** ← 윈도우 B | 이론+실습 | 🟡 | 35–44장 |
| 17:10–17:20 | 질의응답 | | – | |

시간 배분 근거: M1은 6장 분량이라 40분. M3는 실습 4개(ponytail 시연 · claude-mem · Playwright · 설치)라 60분. M5는 스킬 두 개를 만들고 API 두 개와 테스트를 돌리므로 80분. M6는 MCP 실습 1개와 Hook 실습 2개라 100분.

### M1. 코딩 모델 동향과 벤치마크 (40분) — 인트로 덱

**같은 도구, 다른 결과** — 84%가 AI를 쓰지만 결과는 3배 넘게 벌어진다 (인트로 1장)

- **상용 모델 (2장)** — Anthropic Opus 5.5 · Fable 5.2 · Sonnet 5.5 · Haiku 5.5, OpenAI GPT-6 Astra · GPT-6.1 Sol / GPT-6 Luna. 가격 차이 25배 → **작업 난이도에 모델을 맞추는 것이 첫 번째 절약**
- **오픈 웨이트 (3장)** — Kimi K3.1 Pro · GLM-5.3 · DeepSeek V4 Pro · Qwen3.8 2.4T · MiniMax M3.1 Flash · Mistral Large 4. 전부 MoE (총 파라미터 = 메모리, 활성 파라미터 = 연산량). 상용과의 지능 지수 차이를 감수하고 얻는 것은 **데이터를 내보내지 않는 선택지**
- **소형 모델 (4장)** — Flint · Qwen3.8 27B · Gemma 4 31B · Muse Glimmer. 노트북·사내 서버 한 대에서 구동. **작을수록 하네스가 결과를 좌우한다**
- **벤치마크 읽는 법 (5장)** — SWE-bench Pro(결과물) · Terminal-Bench(행위) · DeepSWE(장기 개발) · LiveCodeBench(인지). 재는 대상이 달라 순위가 다른 것이 정상. 포화된 SWE-bench Verified는 제외
- **아직 움직이는 중 (6장)** — 10개월에 주요 모델 약 20개, 포화되면 시험을 바꾼다 → **바뀌어도 살아남는 것(하네스와 루프)에 투자한다**

### M2. 에이전틱 코딩과 하네스 — Claude Code 시작하기 (50분) 🟢

**개념 (1–5장, 20분)**

- 대화 상대에서 동료로: 자동완성 → 대화 → 워크플로 → 에이전트. 제어 흐름이 사람에서 모델로 넘어간다
- 한 번의 요청, 다섯 단계: Explore → Explore → Plan → Implement → Commit. **되돌아가는 화살표가 있으면 에이전트** — 우리가 설계하는 것은 멈추는 조건과 되돌아가는 규칙
- 패러다임 변화: Prompt → Context → **Harness Engineering**
- **Agent = Model + Harness** — 하네스는 LLM 이외의 모든 것(런타임 · 도구·메모리 · 가드레일·검증 루프). Claude Code 구조: Master Agent Loop · Permission Gate · Knowledge · Execution · Observability

**실습 · RECIPE 01 (6장, 15분)** — 설치 · 로그인 · `/status` → `cd edu-stock-chart` → `/model sonnet` `/permissions` `/context` → 첫 프롬프트("구조와 실행 방법을 `docs/analysis.md`로 정리") → `/context` 전후 비교

- 관찰: 어떤 파일을 어떤 순서로 여는가, 파일 쓰기 직전에 멈춰 묻는가(Permission Gate)

**도구 익히기 (7–10장, 15분)**

- Orca — Claude Code · Codex를 워크트리별 탭으로 병렬 실행 (소개)
- 매일 쓰는 명령: `/context` `/clear` `/compact` `/model` `/usage` · `/diff` `/rewind` `/resume` `/branch` `/btw` `/status`
- 하네스를 만드는 명령: `/init` `/memory` `/permissions` `/hooks` `/skill-creator` `/mcp` `/plugin` `/code-review` `/security-review` `/doctor`
- 키: `Shift+Tab`(권한 모드 순환 — AUTO · MANUAL · ACCEPT EDITS · PLAN), `Esc`(중단), `Esc Esc`(되감기), `Ctrl+R`

### M3. 플러그인 (60분) 🟡

오늘 개발에 실제로 쓸 도구만 고른다. **필요 없는 것을 켜면 컨텍스트만 차지한다.**

**플러그인 지도 (11–17, 19, 21장, 15분)**

| 분류 | 플러그인 | 수업에서 |
|---|---|---|
| 계획 · 품질 프로세스 | superpowers · agent-skills · aidlc · feature-dev · code-simplifier · commit-commands · hookify · claude-md-management | superpowers는 M11 시연 |
| 코드 품질 · 안전 | jdtls-lsp · typescript-lsp · security-guidance · claude-security · code-modernization · frontend-design · ponytail | ponytail 시연 |
| 외부 연동 · 메모리 | context7 · playwright · github · atlassian · claude-mem | context7(M6) · playwright · claude-mem 실습 |
| 문서화 · 시각화 | eli5 · archify · hyperframes · graphify | eli5(M4) · graphify(M8) · archify(M12) 실습 |
| 기본 제공 | `/code-review` · `/security-review` · `/simplify` | M10 실습 |

- 설치 (13–14장): `/plugin` Discover → `/plugin install context7@claude-plugins-official` → `/reload-plugins` · `claude plugin list`. 공식 마켓 밖은 `/plugin marketplace add <repo>` · 스킬만 있는 저장소는 `npx skills add`(프로젝트 폴더, `-g` 없이) · eli5는 zip 해제
- **플러그인은 훅과 MCP 서버를 실행할 수 있다** — 상세창(Will install)을 읽고, 서드파티는 검토 후 설치
- 스킬 팩 두 가지 (15–16장): superpowers(자동 발동) vs agent-skills(`/spec` → `/plan` → `/build` → `/test` → `/review` → `/ship`) — 설명만, 시연은 M11

**실습 · RECIPE 05 (18장, 25분)** — ponytail(강사 시연): `/ponytail:ponytail-review MovingAverageService.java` → 「위치 · 자를 것 · 대체」 · `net: -N lines`. claude-mem(실습): `/learn-codebase`(약 5분 · 토큰 소모 큼) → 웹 뷰어(`127.0.0.1:37777`)로 기억 확인 → 새 세션에서 코드를 다시 읽지 않고 답하는가

**실습 · Playwright (19–20장, 20분)** — `/plugin install playwright@claude-plugins-official` → `scripts/start` → AI가 Swagger(`/swagger-ui.html`)를 열어 `GET /api/dashboard/indices`를 Try it out → 200 · 첫 지수 달러 인덱스 102.00 → `stop`

### M4. CLAUDE.md와 Skill 개념 (60분) 🟢

**1. 프로젝트 구조와 CLAUDE.md (22–25장, 15분)**

- `.claude/` 구조: `settings.json`(팀 공유) · `settings.local.json`(개인) · `commands/` · `skills/` · `agents/` · `.mcp.json` · plugins · hooks
- CLAUDE.md 로딩 계층: 조직 정책 → `~/.claude/CLAUDE.md` → `./CLAUDE.md` → `./CLAUDE.local.md` → 하위 폴더(그 폴더 파일을 읽을 때). 덮어쓰지 않고 이어 붙인다
- 넣을 것: 기술 스택 · 명령어 · 프로젝트 구성(Controller → Service → Mapper) · Git 규칙 · 프로젝트 설명
- 좋은 CLAUDE.md 5가지(HumanLayer): 꼭 알려줄 것만 · 모든 작업에 해당하는 것만 · 점진적 공개(세부는 별도 md, `file:line`) · 스타일은 린터에게 · `/init`은 초안으로만. **지시가 늘수록 전부 고르게 덜 지켜진다**

**2. 실습 · RECIPE 06 CLAUDE.md 만들기 (26장, 15분)** — `/init` → 100줄 이하로 정리 → Git 규칙 추가(`feature/*` → `main`, 한글 `type: 요약`) → `/context`에서 Memory files 확인 → 새 세션에서 "테스트는 어떻게 실행해?"

**3. Skill 개념 (27–30장, 15분)**

- Skill = 특정 작업을 매번 같은 품질로 끝내도록 지시 · 맥락 · 자료를 묶은 **플레이북**. 절차 · 예시 · 자료(references/ · scripts/) · 맥락·규칙 · 템플릿(assets/)
- 점진적 공개: 세션 시작엔 name · description만 → 요청이 맞으면 SKILL.md 본문 → 본문이 가리킬 때만 references → 스크립트는 실행 결과만. **description은 모델이 읽고 켤지 정하는 문장**
- 원칙: **영역이 겹치지 않게 · 스킬 하나에 의도 하나**. SW 개발 스킬 9카테고리(라이브러리 레퍼런스 · 제품 검증 · 데이터 · 업무 자동화 · 스캐폴딩 · 코드 품질 · CI/CD · 런북 · 인프라)

**4. 사전 실습 · eli5 (31장, 15분)** — `eli5-pack\eli5.zip`을 `edu-stock-chart\.claude\skills`에 해제 → `/eli5 … 초등학생에게` → 매니저 · 신입 개발자로 대상 바꾸기 → **쉬운 말이 곧 정확한 말은 아니다** — 코드와 대조

### M5. Skill로 API 개발 (80분) 🟡

**코드는 직접 타이핑하지 않는다. 팀 규칙을 Skill에 담고, Skill로 API를 만든다.**

**실습 1 · api-scaffold (32–33장, 45분)**

1. `skill-creator` 확인·설치 → `/skill-creator`로 `api-scaffold` 생성 (계획 → 기존 코드 스캔 → Controller → Service → MyBatis Mapper · XML → `./gradlew test`)
2. 팀 규칙 5가지 + assets 템플릿 4개: Controller의 Mapper 직접 호출 금지 · RESTful(조회 GET · 생성 POST · 복수형 명사) · `@RestController` + `@RequestMapping("/api/...")` · Swagger `@Tag` · `@Operation` · `@Parameter` 필수 · 생성자 주입(`@RequiredArgsConstructor`)
3. `/api-scaffold 계좌 잔고 조회 API` → `110-1234-5678` → 홍길동 · 1,500,000, 없는 계좌 404
4. 새 세션에서 슬래시 없이 **거래량 등록 · 조회 API** → api-scaffold 자동 호출 · 201 · 200 · 404 · 400 테스트

**실습 2 · test-writer — 직접 해 보기 (34장, 35분)**

- `test-writer` 스킬: `@SpringBootTest` · `@Transactional` 자동 롤백 · `@BeforeEach`/`@AfterEach` · 순서 의존 금지 · `@DisplayName` 한국어 · given/when/then · 금액은 `isEqualByComparingTo`
- 대상 `MovingAverageService` → `MovingAverageServiceIntegrationTest` 정상(005930 · window 3 → 8개 · 첫 값 70,133.33) · 없는 종목 예외 2케이스만 → `./gradlew cleanTest test` 두 번 연속 통과 · 로직을 일부러 틀리면 실패하는가

> **산출물**: `CLAUDE.md` + `.claude/skills/api-scaffold` · `.claude/skills/test-writer` + 계좌 잔고 · 거래량 API와 테스트

### M6. MCP와 Hook (100분) 🟡

**MCP (35–39장, 40분)**

- MCP = AI 에이전트를 시스템에 꽂는 표준 연결 (Host · Client · Server, 도구·리소스·프롬프트)
- **Skill은 아는 것을, MCP는 할 수 있는 것을 늘린다** — 외부에 닿아야 하면 MCP, 반복되는 규칙·절차면 Skill, 둘 다 아니면 CLAUDE.md
- 개발자가 많이 쓰는 MCP 8분류: 저장소(GitHub·GitLab) · 이슈/문서(Atlassian) · 전문 I/O(사내 제작) · DB 스키마(dbhub) · 라이브러리 문서(context7) · 브라우저(playwright) · 관측(grafana) · 사내 데이터 표준(사내 제작). 원칙: **읽기 전용 · 최소 권한 · 운영 DB 연결 금지**
- **실습 · context7**: `/model claude-sonnet-4-6` → `claude mcp add --transport http --scope project context7 https://mcp.context7.com/mcp` → `/mcp` 인증 → "Spring Boot 4 REST API 버전 관리 … use context7" → 끄고 같은 질문
- 결과 (39장): context7 없이는 웹 검색 블로그를 근거로 **존재하지 않는 yml 키**(`enabled` · `header` · `default-version`)를 답하고 오류 없이 무시된다. context7을 켜면 공식 소스 기준 `use.header` · `default` · `supported`

**Hook 개념 (40–42장, 15분)**

- **CLAUDE.md는 부탁, Hook은 보장이다** — 세션 시작 · 프롬프트 입력 · 도구 실행 전후 · 작업 끝 · 대기 중에 반드시 실행
- 시점 33개 중 자주 쓰는 것: `SessionStart` · `UserPromptSubmit` · `PreToolUse` · `PostToolUse` · `Stop` · `SubagentStop` · `PreCompact`. `exit 2`로 막을 수 있다
- 에이전트마다 hook 형식이 다르다 (Claude Code settings.json 셸 명령 · opencode JS/TS 플러그인 · pi agent TS 확장)

**실습 · Hook 1 — 깨지면 스스로 고친다 (43장, 20분)**

- Stop hook: `./gradlew test pmdMain build -q 1>&2 || exit 2`
- 일부러 `System.out.println` · 미사용 변수 추가 → Stop hook이 PMD 위반 2건(SystemPrintln · UnusedLocalVariable)으로 막음 → **입력 없이** AI가 스스로 고칠 때까지 대기
- 핵심: gradle 실패는 exit 1(알리고 끝) — **exit 2여야 막고 에러를 AI에게 돌려준다**. 무한 반복은 `stop_hook_active`로 방지

**실습 · Hook 2 — 막고, 남긴다 (44장, 25분)**

- PreToolUse(`Edit|Write`): `application.yml`이면 「설정 파일은 수정 금지」 + exit 2 → `.claude/hooks/block-config.py`
- PostToolUse(`Edit|Write`): 시간 + 파일 경로 → `.claude/edit-log.txt` (`.claude/hooks/log-edit.py`)
- 규칙: Python 파일(jq · `python -c` 금지) · utf-8 · 한글 샘플로 exit 2/0 확인 · 명령은 `python3`(macOS) / `python`(Windows)
- **Pre는 막을 수 있고 Post는 못 막는다** — Post는 기록·포맷·알림 같은 후처리용

> **산출물**: `.mcp.json`(context7) + `.claude/settings.json`(Stop · PreToolUse · PostToolUse 훅) + `.claude/hooks/*.py`

---

## 4. Day 2 — 루프와 그래프, 그리고 AI-SDLC

**오전: 컨텍스트를 쌓고 나만의 루프로 기능을 추가한다. 오후: 리뷰와 AI-SDLC 한 사이클을 본다.**

| 시간 | 세션 | 형식 | 토큰 | 자료 |
|---|---|---|---|---|
| 09:00–09:10 | 오늘의 진행 방식 | 안내 | – (프롬프트 금지) | |
| 09:10–10:00 | **M7. 엔지니어링의 진화 — 컨텍스트 · 루프 · 그래프** | 이론 | – | 45–46 · 52–54 · 64장 |
| 10:10–11:00 | **M8. 실습 — 컨텍스트 쌓기와 나만의 루프** ← 윈도우 A 시작 | 실습 | 🟡 | 47–51 · 55장 |
| 11:00–12:00 | **M9. 실습 — 루프로 기능 API 추가 구현 ①** 과제 1 순위 필터·정렬 | 실습 | 🟡 | 56–59장 |
| 12:00–13:00 | 점심 | | | |
| 13:00–13:50 | **M9. 실습 — 루프로 기능 API 추가 구현 ②** 과제 2 종목 검색 | 실습 | 🟡 | 60–63장 |
| 13:50–14:50 | **M10. 코드 리뷰와 AI-SDLC** | 이론+실습 | 🟡 | 65–72장 |
| 15:00–16:10 | **M11. 강사 시연 — superpowers로 AI-SDLC 한 사이클** | 데모 | 🔴 (강사만) | 73–74장 |
| 16:20–17:10 | **M12. 산출물과 트렌드** ← 윈도우 B | 실습+이론 | 🟢 | 75–82장 |
| 17:10–17:20 | 질의응답 | | – | |

시간 배분 근거: M9는 `/goal`이 재시도를 포함해 끝까지 도는 데 과제당 40~50분이 걸리므로 점심을 사이에 두고 두 번(110분). M10은 리뷰 실습(25분)과 AI-SDLC 이론(35분). M12는 덱 순서대로 archify 실습(75–77장) 뒤에 트렌드(78–82장).

### M7. 엔지니어링의 진화 — 컨텍스트 · 루프 · 그래프 (50분)

**프롬프트에서 그래프까지 (45장, 5분)** — Prompt(메시지) → Context(기억) → Harness(기계) → **Loop(반복 실행)** → **Graph(조율)**. 엔지니어링의 단위가 입력 하나에서 전체 작업으로 넓어진다

**컨텍스트 · RAG (46장, 10분)** — 핵심은 양이 아니라 맞는 정보

| 저장소 | 찾는 방식 | 이럴 때 | 약점 |
|---|---|---|---|
| Vector DB | 뜻으로 | 사내 규정 · 매뉴얼 · FAQ | 숫자 · 관계 · 최신 여부 |
| Graph DB | 관계로 | 「이걸 바꾸면 어디가 영향받나」 | 설계·구축 비용 |
| LLM Wiki | 정리해 두고 읽는다 | 사람과 AI가 함께 쌓는 프로젝트 지식 | 원문이 바뀌면 재정리 |

**루프 엔지니어링 (52–54장, 20분)**

- Prompt(한 번) vs **Loop(통과할 때까지 다시)** vs Graph(여러 루프를 엮고 관문에 사람) — Day 1의 Stop hook이 작은 루프다
- **사람은 「완료」를 정하고, AI는 통과할 때까지 돈다**: 완료의 정의(목표 · 증거 · 경계 · 배경) → 반복(계획 → 실행 → 검증 → 학습) → 멈춤 조건(통과 · 실패 · 불가능 → 사람에게) → **브레이크(최대 반복 + 비용 상한)**
- 루프의 세 가지 — 누가 끝을 정하나: 턴 기반(Claude가 판단) · 목표 기반 `/goal`(다른 모델이 채점) · 시간 기반 `/loop`(사람이 멈출 때까지)

**그래프 엔지니어링 (64장, 15분)**

- 그래프는 노드(사람 · 결정 · 장애 · 작업자)와 엣지(연결)뿐 — 나누고 · 동시에 돌리고 · 검사해 합친다
- **비슷한 것이 아니라 연결된 것을 찾는다**: 「Redis를 왜 뺐나?」 — 벡터는 Redis 언급 글 10개, 그래프는 이유의 사슬 3개(Job queue → ADR-007 → ADR-003 → 장애)
- 타입 있는 엣지(`supersedes` · `depends_on` · `caused`), 여러 단계 연결에 강하고 단순 조회엔 벡터가 낫다
- 주의: 「같은 대상」 판단이 틀리면 단계마다 오류가 곱해진다

### M8. 실습 — 컨텍스트 쌓기와 나만의 루프 (50분) 🟡

**1. LLM Wiki · obsidian-second-brain (47–50장, 20분)** — 코드를 위키로 만들고, 위키로 코드를 만든다

- `obsidian-init`(빈 vault `koscom-wiki`, wiki 레이아웃) → `obsidian-architect .`(Architecture 7 · 파일별 Code 노트 17, 지어내지 않기 · `@generated`/`@user` 블록) → Obsidian Graph view(토큰 0)
- `obsidian-find`(위키 근거로 호출 흐름 · 테스트) · `capture` · `decide --formal`(이유는 TBD — 지어내지 않는다) · `log` · `ingest --preview` · `health`
- 증분 갱신: `scanned-commit` 이후 바뀐 파일만 · `@user` 메모 유지 — **전체 생성은 처음 한 번만**

**2. graphify — 코드를 그래프로 (51장, 15분)** — `/graphify src/main/java` → `graph.html` · `GRAPH_REPORT.md` → `/graphify path "StockController" "StockPriceMapper"` → `/graphify query "findBySymbol 을 바꾸면 영향받는 곳" --budget 800` → 그래프를 근거로 변경 계획(파일을 다 열지 않는다). `graphify-out/`은 git에 올리지 않는다

**3. `/goal` · `/loop` (55장, 15분)**

- `/goal` — `MovingAverageServiceTest`에 window 경계값 테스트: [완료] 1 · 21 예외 + 메시지 · 2 · 20 정상 · test exit 0 [제약] 이 파일만 · 삭제 · `@Disabled` 금지 [멈춤] 10턴 [예외] main 수정 필요 · 환경 오류 2회 → 보고하고 멈춤
- `/loop 2m` — 최신 커밋 ↔ 위키 `scanned-commit` 비교, 다르면 architect 증분 갱신 (별도 세션, 말로 취소 · 운영에서는 post-commit hook)

> **산출물**: 코드 위키 · 코드 그래프 + 완료 기준 · 멈춤 조건 · 예외 조건을 갖춘 나만의 `/goal` 프롬프트

### M9. 실습 — 루프로 기능 API 추가 구현 (110분) 🟡

**사람은 시작과 끝만, 가운데는 `/goal`이 돈다.** 과제 명세는 `docs/practice/m9-ranking-filter.md` · `m9-stock-search.md`, 강사 노트(비배포)는 `m9-instructor.md`.

| | 과제 1 · 순위 필터·정렬 (56–59장) | 과제 2 · 종목 검색 (60–63장) |
|---|---|---|
| 화면 | 전체/국내/해외 · 거래대금/급상승/급하락 버튼이 이미 `GET /api/dashboard/rankings?market=&sort=` 호출 — 지금은 17개 그대로 | 검색창이 이미 `GET /api/stocks/search?q=` 호출 — 지금은 「검색 기능 준비 중」 |
| 명세 | `market` ALL/DOMESTIC/OVERSEAS · `sort` TRADE_AMOUNT/RISE/FALL · 동률은 `rank_no` · 정해진 값 외(소문자 포함) 400 | symbol 또는 name 부분 일치 · 대소문자 무시 · `%` `_`는 글자 그대로 · trim, 공백뿐이면 400 · name 오름차순 최대 10건 |
| 범위 | Controller → Service → Mapper · SQL은 `DashboardMapper.xml` | 검색용 Controller · Service · Mapper 새로 |
| 확인 | 국내+급상승 7개 · 1위 코스모스바이오 +29.94% · 해외+급하락 1위 SOXS | 삼성 → 삼성SDI부터 4개 · tsla → 테슬라 · `0` → 10개 |
| 공통 | `StockController` · `MovingAverageService` 수정 금지 · `./gradlew test` 통과 · 명세 각 줄을 검증하는 테스트 · 다시 띄운 화면에서 동작 | |

**진행 (과제마다 같은 흐름)**

1. 사람: `scripts/start`로 구현 전 화면 확인 → `stop`
2. 사람: `/goal` 한 번 입력 — [순서] 구현 → `./gradlew test` → start · Playwright로 화면 점검 · stop [완료] 테스트 · BUILD SUCCESSFUL · 화면 표 + 스크린샷 [재시도] 「재시도 n/15」, 15번째 실패 → 보고하고 멈춤 [예외] 금지 파일 수정 필요 · 시드 불일치 · 포트 사용 중 · 환경 오류 2회
3. AI 루프: 구현 → 테스트 → 화면 점검 → 다른 모델이 대화만 보고 판정. **입력하지 않고 지켜본다** — 잘못 가면 코드를 고치지 말고 기록
4. 사람: 다시 띄워 확인 → 무엇이 부족해 헤맸는지 CLAUDE.md · 훅 · 완료 기준에 반영 → 과제 2로 2차 실행

| 증상 | 고칠 곳 |
|---|---|
| `${}` SQL(`ORDER BY ${sort}` · `LIKE '%${q}%'`) | CLAUDE.md 규칙 + 훅으로 `${` 차단 — 테스트로는 안 잡힌다 |
| 잘못된 값에 400 대신 500 · 공백 검색어에 200 | 완료 기준에 400 테스트 명시 |
| 한 경우만 테스트하고 끝냄 | 완료 기준을 명세의 행 단위로 |
| 범위 밖 파일 수정 · 계층 위반 | 범위 규칙 · 허용 목록 · 계층 규칙 |
| 삼성SDI가 먼저인 것을 버그로 보고 고침 | 정상(H2는 영문이 한글보다 앞) — 확인용 예시를 테스트 기대값으로 |

- **1차 vs 2차** — 턴 수 · 개입 횟수 · 같은 실수 반복 · 화면까지 확인했는가. **무엇을 고쳤더니 무엇이 좋아졌는가**

### M10. 코드 리뷰와 AI-SDLC (60분) 🟡

**코드 리뷰 — 새 병목 (65–67장, 25분)**

- 코드는 싸졌고, 리뷰가 새 병목이 됐다: AI 도입이 많은 팀에서 병합 PR +98% · 리뷰 시간 +91% · PR 크기 +154% · 개발자당 버그 +9%, 조직 배포 속도는 그대로 (Faros AI, 2025)
- **테스트 통과 ≠ 좋은 코드** — M9의 `${}` 인젝션 · 500 · 범위 밖 수정은 테스트가 못 잡는다. AI가 1차로 거르고, 사람은 설계 · 요구사항 판단에
- **쓴 사람이 채점하면 점수가 후하다**: 자기 선호 편향(NeurIPS 2024) · 외부 피드백 없는 자기 수정의 한계(ICLR 2024) · 같은 대화는 「왜 이렇게 짰는지」를 이미 들었다 · 꽉 찬 컨텍스트 → **Writer / Reviewer 패턴, 별도 세션에서 리뷰**
- **실습**: 새 터미널에서 `claude` → `/model claude-opus-5-5` → `/code-review`(변경 전체) → `/code-review high src/main/java/.../service` → `/code-review HEAD~1..HEAD` → `/model claude-sonnet-5-5`. `--fix`는 쓰지 않는다 — 고칠지는 사람이 골라 작성 세션에 넘긴다 (Claude Code v2.1.223+, `--max-findings`는 v2.1.288+)

**AI-SDLC (68–72장, 35분)**

- 배경: Anthropic은 Plan → Build → Deploy를 일직선이 아니라 Claude 중심의 **순환 루프**로, AWS는 **AI-DLC**로 정의 중
- **병목은 코드에서 그 앞뒤로 옮겨갔다** — 지킬 것(품질 · 승인 · 기록)은 그대로, 확인 방법만 AI 속도로. 각 단계가 다음 단계가 읽을 산출물을 git에 남긴다: `intent.md` → `spec.md` → `plan.md` → diff + 테스트 → PR · 리뷰 결과 → 배포 → 인시던트 기록(→ 새 `intent.md`)

| 단계 | 산출물 | 사람 게이트 |
|---|---|---|
| Plan | `intent.md` | 프로덕트 오너 승인 |
| Design | `spec.md` | PO 리뷰 · 고위험이면 테크리드 |
| Build | `plan.md` · diff | 엔지니어가 plan 승인 |
| Test | 테스트 결과 · 빌드 로그 · 스크린샷 | 코드 소유자 (증거 첨부 리뷰) |
| Deploy | PR · 리뷰 결과 · 배포 기록 | 코드 소유자 · 운영은 릴리스 매니저 |
| Maintain | 인시던트 기록 · 새 `intent.md` | 서비스 소유자 · on-call |

- **통제는 문서가 아니라 하네스로**: 권고(CLAUDE.md · Skill — 위반 가능) · 강제(Hook · 관리형 설정 — 항상 지켜지고 로그) · 판단(사람 승인 — branch 보호 · 릴리스 서명). **꼭 지켜야 할 정책은 Skill이 아니라 Hook으로**
- 산출물이 모두 버전 관리되니 커밋 · 작성자 · 시각이 그대로 **감사 추적**이 된다
- **사람은 실행자에서 게이트의 판단자로**: PO(intent·spec 검토) · 엔지니어(여러 세션 오케스트레이션 · plan 승인) · QA(평가 세트) · 플랫폼(Hook · Skill · 관리형 설정) · 기술 리드(REVIEW.md · CLAUDE.md · 위험 등급) · 보안 리드(정기 스캔)

### M11. 강사 시연 — superpowers로 AI-SDLC 한 사이클 (70분) 🔴

**토큰을 많이 쓰는 구간이라 강사 계정으로만 실행한다. 수강생은 관찰하고 질문한다.**

- **과제 (73장)**: 순위 1위 SOXL 행 클릭 → 지금은 `GET /api/stocks/SOXL/detail` 404 → 「아직 구현되지 않았습니다」 팝업. 구현 후 `#/stocks/SOXL` 상세 화면(113,134원 +2.23% · 52주 범위 · 체결강도 · 일봉 62개 · 투자자별)
- **시연 흐름 (74장)** — 사람 승인이 붙은 단계는 사람이 고르기 전에 넘어가지 않는다

| 단계 | superpowers 스킬 | 사람 |
|---|---|---|
| 01 Plan · Design | brainstorming → spec | 승인 · 설계 |
| 02 Build 준비 | writing-plans → 2~5분 단위 plan, 작업마다 테스트 먼저 | 승인 · 계획 |
| 03 Build · Test | executing-plans · TDD (실패 테스트 → 구현 → 통과) | AI 진행 |
| 04 Verify | Playwright로 SOXL 클릭 → 상세 화면 | AI 진행 |
| 05 Review | requesting-code-review → 심각도별 이슈 | 무엇을 고칠지 판단 |
| 06 Deploy 준비 | finishing-a-development-branch | merge · PR · 보관 · 폐기 선택 |

- 「한 번에」 프롬프트: 단위 테스트 규약 · 커버리지(신규 100%) · 리뷰 요건 · 반복 횟수 제약 포함 · 설계 · 계획 · 리뷰 · 마무리에서 멈추고 승인 대기. specs = intent · spec, plans = plan.md, 리뷰 = PR 게이트

### M12. 산출물과 트렌드 (50분) 🟢

**에이전트는 코드만이 아니라 그림 · 영상도 만든다 (75–76장, 10분)** — archify(탐색용 HTML 다이어그램) · drawio-skill(팀이 계속 고치는 .drawio) · hyperframes(HTML → MP4). 결과가 파일로 남아 git으로 관리하고, 코드가 바뀌면 같은 요청으로 다시 만든다

**실습 · archify 시퀀스 다이어그램 (77장, 25분)**

1. `GET /api/stocks/{symbol}/moving-average`: Client → StockController → MovingAverageService → StockPriceMapper → H2 (코드에 없는 호출은 넣지 않는다)
2. 화살표마다 코드 위치(파일:줄) 표로 대조 — `fetchWithRetry` 같은 숨은 단계가 빠지지 않았는가
3. `fetchWithRetry` 재시도(최대 3번)를 loop로 표시해 **같은 파일** 갱신

**트렌드 (78–82장, 15분)**

- **Jev** — System One 모델: 글 대신 선택 · 점수 · 확률을 70~500ms에 돌려준다. 루프의 검사 · 그래프의 라우터 · 실행 전 가드레일 · 리뷰 우선순위처럼 자주 도는 판단을 맡긴다 (얼리 액세스 · 수치는 회사 발표)
- **REA** — Reverse Engineer Anything: 로컬 MCP 서버로 바이너리 · APK · 웹을 분석 (허가받은 대상만)
- **Hallmark** — AI가 만든 티가 나지 않는 디자인 스킬 (`/hallmark` · `redesign` · `audit`)

---

## 5. 사전 준비물

### 수강생 (교육 전 확인)

- **사전 설문** `docs/00-intro/pre-survey.md` (약 3분) — 수준별 진행 속도 조정용
- **설치 스크립트** `install/` (Windows 10 1809+ / 11 · PowerShell 5.1+ · winget): `1-check.bat` → `2-download.bat`(선택) → `3-install.bat` → 터미널 새로 열고 `claude` 로그인 → `4-claude-setup.bat` → `1-check.bat` 재점검

| 구분 | 도구 | 용도 |
|---|---|---|
| 필수 | Git for Windows 2.40+ | Claude Code가 Git Bash 사용 · clone · worktree |
| 필수 | Node.js LTS 22+ | `edu-stock-chart-ui`(Vite) · `npx skills` · Playwright MCP · HyperFrames |
| 필수 | JDK **21** (Azul Zulu) | Spring Boot 3.4 · Gradle 8.6 · toolchain 21 (다른 버전 JDK · `JAVA_HOME` 충돌 점검) |
| 필수 | Claude Code 2.1.223+ | 과정 전체 · `/code-review` |
| 권장 | Python 3.12 · uv | graphify · obsidian-second-brain |
| 권장 | Chrome | Playwright 화면 검증 · Hallmark |
| 권장 | Obsidian · FFmpeg · Orca | LLM 위키 · HyperFrames 렌더 · 병렬 에이전트 |
| 선택 | `gh` CLI · GitHub 계정 | PR 생성 · PR 리뷰 (설치 스크립트에 없음 — 필요 시 별도 설치) |

- `4-claude-setup.bat`이 설치하는 것: 플러그인 superpowers · playwright · context7 · skill-creator · hyperframes · ponytail · claude-mem · obsidian-second-brain / Skill archify(프로젝트 폴더) · drawio-skill · hallmark · eli5(zip) · graphify
- Team 계정 로그인 확인 (**`claude --version` · `/status` 정도만, 프롬프트 사용 자제**)
- 8080 · 5173 포트를 비워 둔다

### 강사/운영

- 실습 프로젝트 `edu-stock-chart` + `edu-stock-chart-ui` + `scripts/`(start · stop · status) — 시드 데이터 · 미구현 API를 부르는 화면 포함
- M9 과제 명세 2종 + 강사 노트(함정 · 참고 구현)
- **M11 시연 시나리오** — superpowers 「한 번에」 프롬프트, SOXL 상세 화면 기준 캡처
- **좌석 유형 확인 + 사용 크레딧 활성화(1인당 상한 포함) + 예비 계정 1~2석**
- 리허설 실측 결과(모듈별 `/usage` 소모율)

---

## 6. 레포 구성

```
edu-coding-ai-agent/
├── docs/
│   ├── curriculum/              # 본 문서 · summary.md
│   ├── 00-intro/                # 인트로 덱(모델 동향 · 벤치마크) · 사전 설문
│   ├── 01-agentic-coding/slide/ # 에이전틱 코딩 덱(82장) · assets
│   ├── pdf/                     # 통합 PDF
│   ├── practice/                # M9 과제 명세 · 강사 노트 · LLM 위키 실습 기록
│   ├── ai-sdlc/                 # AI-native SDLC 플레이북 · 흐름도
│   ├── superpowers-workflow/    # superpowers 흐름도
│   ├── agent-skills-workflow/   # agent-skills 흐름도
│   └── ref/                     # 상용 · 오픈 웨이트 모델 참고
├── edu-stock-chart/             # Spring Boot API (MyBatis + H2 · PMD · Swagger)
├── edu-stock-chart-ui/          # Vite + Chart.js 대시보드
├── scripts/                     # start · stop · status (.ps1 · .sh · .bat)
├── install/                     # Windows 교육 환경 설치 (check · download · install · claude-setup)
├── setup/                       # 최소 설치 (Git · Node · JDK 만)
└── eli5-pack/                   # eli5 스킬 zip (git 없이 설치)
```
