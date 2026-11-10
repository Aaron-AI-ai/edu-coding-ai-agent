# 빅테크 코딩 모델 현황

> 기준일 2026-11-01 · 웹 검색 정리. 성능 수치는 대부분 **제조사 자체 보고**라 도입 전 직접 비교가 필요하다.

## 모델 한눈에 보기

| 회사 | 모델 | 시점 | 메모 |
|---|---|---|---|
| Anthropic | Opus 5.5 / Sonnet 5.5 / Haiku 5.5 | 9/22 · 9/28 · 10/7 | 5.5 계열, 컨텍스트 1M. Haiku 5.5는 $0.1·$0.5 (1M 토큰당 입력·출력) |
| Anthropic | Fable 5.2 | 11/9 | 가장 능력 높은 일반 공개 모델(코딩·과학·금융). $8·$40(Fable 5.1은 $10·$50), 컨텍스트 1M, 기본 effort high. 일상 코딩은 Opus 5.5 권장 |
| OpenAI | GPT-6 Astra · GPT-6.1 Sol · GPT-6 Luna | 2026.09~ | Astra $10·$50 (1.05M), Sol $2·$10, Luna $0.1·$0.5 |
| Google | Gemini 4 Argon | 9/30 발표 · 10/13 일반 공개 | 저장소 단위 코딩에 강점 |
| xAI | Grok 4.7 | 9/21 | 저렴한 가격, 코딩 · 지식 업무 겨냥 |
| Meta | Muse Spark 1.1 | 2026.07 | 오픈 계열은 Muse Spark Open(816B, 활성 42B), 소형은 Muse Glimmer(30B, Apache-2.0) |

## 평가 요약

- **Grok 4.7** — 가격 대비 성능이 좋다는 평. 다만 코딩 수치 대부분이 xAI 자체 발표이고, 코딩 벤치마크에서는 Claude 계열에 뒤진다는 평가가 있다.
- **Muse Spark 1.1** — SciCode 등 일부 벤치마크는 상위권이지만, 긴 에이전트 작업에서 흐름을 놓친다는 개발자 후기가 있어 평이 갈린다.
- **Gemini 4 Argon** — 저장소 단위 코딩 · DeepSWE에서 앞서지만 터미널 작업은 뒤진다(Terminal-Bench 4.0 57.4% vs Opus 5.5 66.4%, 구글 표 기준). 실제 코딩 성능에 대한 내부 우려 보도가 있었고 구글은 부인했다.

## 읽을 때 주의

- 제조사 표 · 2차 블로그 기반 수치가 많아 **독립 검증이 부족**하다.
- 같은 벤치마크라도 하네스 · 버전(예: Terminal-Bench 2.1 vs 4.0)이 다르면 직접 비교할 수 없다.
- 수업 · 도입 판단에는 **우리 과제로 직접 돌려 본 결과**를 우선한다.

## 출처

- [Grok 4.7 Review](https://blog.buildfastwithai.com/grok-4-7-review)
- [Grok 4.7 Hands-On](https://www.mindstudio.ai/blog/grok-4-7-hands-on-test)
- [Meta Muse Spark 1.1 review](https://www.eesel.ai/blog/meta-muse-spark-11-review)
- [Meta Muse Spark 1.1: what it is, what it costs, where it loses](https://www.eesel.ai/blog/meta-muse-spark-11)
- [Gemini 4 Argon launch benchmark debate (Android Headlines)](https://www.androidheadlines.com/2026/10/google-gemini-4-argon-launch-benchmark-performance-debate.html)
- [Gemini 4 Argon benchmarks (Emergent)](https://emergent.sh/learn/gemini-4-argon-benchmarks)
- [Claude Haiku 5.5 docs](https://platform.claude.com/docs/en/models/haiku-5-5/overview)
- [GPT-6.1 Sol 발표](https://openai.com/index/introducing-gpt-6-1-sol/)
