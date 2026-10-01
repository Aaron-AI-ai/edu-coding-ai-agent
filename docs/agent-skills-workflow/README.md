# agent-skills 기반 개발 라이프사이클 (AI SDLC)

> 출처: [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (v0.6.11 기준)
> 다이어그램: [`agent-skills-workflow.html`](agent-skills-workflow.html) — 브라우저로 열기 (다크/라이트, 확대, 경로 추적 지원)

## 1. 한 줄 요약

agent-skills는 **시니어 엔지니어의 SDLC(요구사항 → 설계 → 구현 → 테스트 → 리뷰 → 배포)를 AI 에이전트가 따르는 "스킬"로 만든 것**이다.
각 단계는 슬래시 커맨드 하나로 시작하고, 상황에 맞는 스킬은 자동으로 활성화된다.

```
  DEFINE        PLAN        BUILD        VERIFY       REVIEW       SHIP
 ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐
 │ Idea │ ─▶ │ Spec │ ─▶ │ Code │ ─▶ │ Test │ ─▶ │  QA  │ ─▶ │  Go  │
 └──────┘    └──────┘    └──────┘    └──────┘    └──────┘    └──────┘
  /spec       /plan       /build      /test       /review     /ship
```

## 2. 전통적 SDLC와의 대응

| 전통 SDLC | agent-skills 단계 | 커맨드 | 핵심 원칙 | 산출물 |
|---|---|---|---|---|
| 요구사항 분석 | DEFINE | `/spec` | 코드 전에 Spec | PRD (목표·명령·구조·스타일·테스트·경계) |
| 설계 / 계획 | PLAN | `/plan` | 작고 원자적인 task | task 목록 + 수용 기준 + 의존 순서 |
| 구현 | BUILD | `/build` | 한 번에 한 slice | slice별 commit |
| 테스트 | VERIFY | `/test` | 테스트가 증거 | RED → GREEN 테스트 |
| 코드 리뷰 / QA | REVIEW | `/review` | 코드 건강도 개선 | 5축 리뷰 결과 (Nit/Optional/FYI) |
| 배포 / 운영 | SHIP | `/ship` | 빠를수록 안전 | 출시 체크리스트 + Go/No-Go |

보조 커맨드: `/constraints`(품질 기준 CONSTRAINTS.md), `/code-simplify`(단순화), `/webperf`(웹 성능 감사)

## 3. 단계별 워크플로우

### ① DEFINE — 무엇을 만들까
- 요구가 모호하면 **`interview-me`**(한 번에 한 질문, 확신 ~95%까지) / **`idea-refine`**(발산→수렴)
- **`/spec`** → `spec-driven-development`: 코드 작성 전 PRD 작성
- 에이전트는 가정을 명시한다: `ASSUMPTIONS I'M MAKING: ... → 지금 수정하지 않으면 이대로 진행`
- 🧑 **Human Gate**: 사람이 spec과 가정을 승인

### ② PLAN — 어떻게 만들까
- **`/plan`** → `planning-and-task-breakdown`
- spec을 **작고 검증 가능한 task**로 분해, 각 task에 수용 기준과 의존 순서

### ③ BUILD — 조금씩 만든다
- **`/build`** → `incremental-implementation`: 얇은 수직 slice 단위로 구현 → 테스트 → 검증 → commit
- 상황별 스킬이 **자동 활성화**:
  - UI → `frontend-ui-engineering` / API → `api-and-interface-design`
  - 공식 문서 근거 필요 → `source-driven-development`
  - 고위험·낯선 코드 → `doubt-driven-development` (새 컨텍스트로 반박 검토)
  - 컨텍스트 품질 저하 → `context-engineering`
- **`/build auto`**: 계획을 한 번 승인하면 모든 task를 자동 실행 (task별 TDD·commit은 유지, 실패·위험 단계에서 멈춤)

### ④ VERIFY — 동작을 증명한다
- **`/test`** → `test-driven-development`: Red-Green-Refactor, 테스트 피라미드 80/15/5
- 버그는 **Prove-It 패턴**: 먼저 실패하는 테스트로 재현
- 브라우저 → `browser-testing-with-devtools`
- 🔁 **실패 루프**: `debugging-and-error-recovery` (재현 → 국소화 → 축소 → 수정 → 가드) 후 BUILD로 복귀

### ⑤ REVIEW — 머지 전 품질 게이트
- **`/review`** → `code-review-and-quality`: **5축** — 정확성 · 가독성 · 아키텍처 · 보안 · 성능
- 변경 크기 ~100줄 권장, 크면 분할
- 필요 시 `code-simplification` / `security-and-hardening` / `performance-optimization`
- 🔁 **변경 요청** 시 BUILD로 복귀

### ⑥ SHIP — 자신 있게 배포
- **`/ship`** → `shipping-and-launch`: 전문가 페르소나에게 **병렬 fan-out** 후 결과 종합
  - `code-reviewer` · `test-engineer` · `security-auditor` · `web-performance-auditor`
- 함께 쓰는 스킬: `git-workflow-and-versioning`, `ci-cd-and-automation`, `observability-and-instrumentation`, `documentation-and-adrs`
- 🧑 **Human Gate**: Go / No-Go 결정 → 단계적 롤아웃, 롤백 절차 준비

## 4. 모든 단계에 공통 적용되는 규칙 (`using-agent-skills`)

1. **가정을 드러낸다** — 모호한 요구를 조용히 채우지 않는다
2. **혼란은 멈추고 묻는다** — 추측으로 진행하지 않는다
3. **필요하면 반대한다** — yes-machine이 아니다
4. **검증은 필수** — "잘 될 것 같다"는 완료가 아니다. 테스트·빌드·런타임 증거가 필요하다

각 SKILL.md는 동일한 구조를 가진다:
`Overview → When to Use → Process → Rationalizations(핑계와 반박) → Red Flags → Verification`

## 5. 설치 (Claude Code)

```
/plugin marketplace add addyosmani/agent-skills
/plugin install agent-skills@addy-agent-skills
```

다른 에이전트: `npx skills add addyosmani/agent-skills`

## 6. superpowers와 비교

| 항목 | agent-skills | superpowers |
|---|---|---|
| 구조 | SDLC 6단계 + 커맨드 9개 | brainstorming → plan → subagent 실행 흐름 |
| 진입점 | `/spec` `/plan` `/build` `/test` `/review` `/ship` | 스킬 자동 트리거 중심 |
| 리뷰 | 5축 리뷰 + 전문가 페르소나 4종 | task별 2단계 리뷰 (Spec → 품질) |
| 강점 | 배포·운영(CI/CD, 관측성, 롤아웃)까지 포함 | 격리(worktree) + subagent 실행 규율 |

→ 참고: [`../superpowers-workflow/`](../superpowers-workflow/)
