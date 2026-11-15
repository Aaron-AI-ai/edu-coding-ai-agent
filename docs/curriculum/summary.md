# 한 장 요약

> **같은 도구, 다른 결과**
> AI Agent 기반 SW 개발의 비법 — 나만 몰랐던 이야기

## 학습 목표

1. AI Agent 시대에 SW 개발자가 갖춰야 할 필수 요소를 이해한다
2. 차세대 금융 시스템에서 많이 활용하는 Spring Boot·Java 기반 미니 프로젝트를 AI Agent로 직접 개발해 본다

## 개발자가 알아야 할 필수 요소 6가지

| # | 요소 | 한 줄 설명 |
|---|---|---|
| 01 | 필수 플러그인 & MCP | 업무에 실제로 쓸 도구만 골라 연결하는 법 (context7 · Playwright · claude-mem 등) |
| 02 | Skill, Rule 설계 | 필요할 때만 불려오는 지식(Skill)과 매번 읽히는 규칙(CLAUDE.md) 설계하기 |
| 03 | 하네스 | CLAUDE.md·Skill·Hook·MCP를 하나로 묶어 AI가 정해진 대로 일하게 만드는 틀 — Agent = Model + Harness |
| 04 | Loop 엔지니어링 | 사람은 「완료」를 정하고, AI는 통과할 때까지 돈다 (`/goal` · `/loop` · Stop hook) |
| 05 | Graph 엔지니어링 | 비슷한 것이 아니라 연결된 것을 찾는다 — 코드 위키 · 코드 그래프 · 여러 루프의 조율 |
| 06 | AI-SDLC | 산출물이 다음 단계로, 사람은 게이트에 — 별도 세션 코드 리뷰와 6단계 승인 |

## 실습 프로젝트

**Spring Boot 3.4 · Java 21 · MyBatis + H2** API와 **Vite + Chart.js** 대시보드로 된 미니 금융 서비스(주식 차트 웹)를 **AI Agent로 직접 구현**하며 하네스·루프를 몸에 익힙니다. 화면은 이미 연결되어 있어 **API만 구현**합니다 — 계좌 잔고 · 거래량 API, 순위 필터·정렬, 종목 검색, 종목 상세(시연).

## Day 1 / Day 2 한눈에 보기

| Day 1 — 하네스 구성과 첫 기능 개발 | Day 2 — 루프·그래프 엔지니어링과 AI-SDLC |
|---|---|
| 코딩 모델 트렌드 파악 및 벤치마크(Bench) 정보 알아보기 | 컨텍스트 · 루프 · 그래프 엔지니어링 개념 |
| 에이전틱 코딩과 하네스 · Claude Code 시작하기 | LLM 위키 · 코드 그래프로 컨텍스트 쌓기, `/goal` 루프 만들기 |
| 플러그인 실습 (ponytail · claude-mem · Playwright) | 나만의 루프로 기능 API 추가 구현 (순위 필터 · 종목 검색) |
| CLAUDE.md와 Skill 개념 | 별도 세션 코드 리뷰 + AI-SDLC 개념 |
| Skill로 API 개발 (api-scaffold · test-writer) | 강사 시연 — superpowers로 AI-SDLC 한 사이클 |
| MCP(context7)와 Hook으로 하네스 완성 | 산출물(archify 다이어그램) · 트렌드(Jev · REA · Hallmark) |

**기간** 2일·14시간 · **대상** Java/Spring Boot 개발자 · **방식** Claude Code 실습 중심 · **산출물** 동작하는 서비스 + 나만의 하네스와 개발 루프
