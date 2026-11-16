# 오픈 웨이트 모델 현황

> 기준일 2026-11-01 · 웹 검색 정리 · 인트로 덱 3장 「가중치가 공개된 오픈 웨이트 모델」의 근거. 성능 수치는 대부분 **제조사 자체 보고**라 도입 전 직접 비교가 필요하다.

## 모델 한눈에 보기

| 회사 | 모델 | 크기 (총 · 활성) | 라이선스 | 잘하는 것 |
|---|---|---|---|---|
| Xiaomi | MiMo-V2.6 Pro | 1.02T · 42B | MIT | 오픈 지능 지수 1위(46) · 에이전틱 코딩 · 비주얼 코딩 |
| Z AI | GLM-5.3 | 753B · 40B | 자체 라이선스 | 터미널 장기 에이전틱 작업 · 1M 컨텍스트 |
| Moonshot AI | Kimi K3 | 2.8T · 104B | Modified MIT | 프론트엔드 코딩 · 긴 코딩 작업 |
| DeepSeek | V4 Pro | 1.6T · 49B | MIT | SWE-bench(실제 저장소 버그 수정) · 1M 긴 문맥 효율 |
| DeepSeek | V4.1 Flash 1017 | 552B · 약 8B | MIT | 에이전틱 코딩 · 터미널 작업을 싼값에 |
| NVIDIA (미국) | Nemotron 3 Ultra | 약 550B · 55B | NVIDIA Open Model License 계열(원문 확인) | 비중국 대형 오픈 모델 |
| NVIDIA (미국) | Nemotron 3 Super | 약 120B · 12B | NVIDIA Open Model License 계열(원문 확인) | 활성 12B 로 가성비 · 자체 호스팅 현실성 |
| Mistral AI (프랑스) | Large 4 | 약 1T · 52B | 수정 MIT | 비중국 대표 · 사이버보안 |

## 모델별 요약

- **MiMo-V2.6 Pro** — Artificial Analysis 지능 지수 46으로 오픈 웨이트 1위(상용 Opus 5.5 는 58). DeepSWE 71.9 · 비주얼 코딩 72.3(샤오미 발표). 가장 어려운 장기 코딩 과제에서는 상용 모델에 뒤진다.
- **GLM-5.3** — Terminal-Bench 3.0 · Agents' Last Exam 에서 오픈 최고(28.3 · 28.5). 1M 컨텍스트 · 최대 약 128K 출력. 5.2(MIT)와 달리 자체 라이선스라 원문 확인이 필요하다.
- **Kimi K3** — 출시 때 Arena 프론트엔드 코딩 리더보드 1위. 1M 컨텍스트. 측정 대부분이 Moonshot 호스팅 API 기준이라 자체 호스팅 성능은 아직 검증이 적다.
- **DeepSeek V4 Pro** — SWE-bench Verified 80.6%(자체) · 74%(NIST 재측정). 1M 토큰에서 V3.2 대비 연산 27% · KV 캐시 10%. V4.1 Flash 출시와 함께 API 에서는 은퇴했다는 보도가 있다.
- **DeepSeek V4.1 Flash 1017** — 2026-10-17, 9월 V4.1 Flash 를 같은 가격에 개선한 체크포인트. DeepSWE 77.0 · Terminal-Bench 4.0 42.3 · HLE 42.6(자체). 크기는 출시 글 552B, Hugging Face 파일 합계 약 763B 로 출처가 엇갈린다.
- **NVIDIA Nemotron 3 Ultra** — 2026-06-04(Computex) 공개로 보도된 최상위 모델(약 550B · 활성 55B). 일부 출처가 지능 지수 48(미국 오픈 1위)로 적지만 **단일 출처 · 미검증**이라 표에는 싣지 않는다. 구형 자료는 아직 '출시 예정'으로 적어 출처가 엇갈린다.
- **NVIDIA Nemotron 3 Super** — 2026-03-11(GTC) 공개, 약 120B · 활성 12B. 활성이 작아 비용이 낮은 중간급. 벤치마크 점수는 확인하지 못했다. 로컬 실행용은 Nano(약 30B · 활성 3B, 2025-12).
- **Mistral Large 4** — 2026-10-29 가중치 공개(FP8 · NVFP4). 지능 지수 38.4 로 Large 3(9.3)에서 크게 올랐지만 중국 상위 모델(44~46)보다는 아래. AA Cyber Index 50 으로 Kimi K3 · DeepSeek V4.1 Flash(41)보다 높다는 발표(Mistral 차트). 크기는 1T · 활성 52B 와 1.05T · 활성 49B 로, 컨텍스트는 512K~1M 으로 출처가 엇갈린다. 수정 MIT 라 API 서비스(MaaS)로 팔 때만 별도 상용 라이선스.

## 고를 때 기준

- 모두 **MoE** — 활성 파라미터가 작아 연산은 가볍지만, **총 파라미터만큼 메모리**(수백 GB)가 필요해 자체 호스팅 부담이 크다.
- 오픈 웨이트 상위는 중국 모델이 차지한다. 비중국 중에서는 Mistral Large 4(38)가 검증된 최고. NVIDIA Nemotron 3 Ultra 는 48 이라는 보도가 있으나 미검증.
- 상용 프론티어 54~58 · 오픈 44~46. 그 차이를 감수하고 얻는 것은 **데이터를 밖으로 내보내지 않는 선택지**다.
- 라이선스가 제각각(MIT · Modified MIT · 자체)이라 **도입 전 원문 확인**은 필수다.

## 읽을 때 주의

- 제조사 표 · 2차 블로그 기반 수치가 많아 **독립 검증이 부족**하다.
- 같은 벤치마크라도 하네스 · 버전(예: Terminal-Bench 3.0 vs 4.0)이 다르면 직접 비교할 수 없다.
- 수업 · 도입 판단에는 **우리 과제로 직접 돌려 본 결과**를 우선한다.

## 출처

- [Xiaomi MiMo V2.6 — The Next Web](https://thenextweb.com/news/xiaomi-mimo-v2-6-open-weight-model-anthropic-distillation)
- [MiMo V2.6 specs — eesel.ai](https://www.eesel.ai/blog/xiaomi-mimo-v2-6)
- [GLM-5.3 released — ZenMux](https://zenmux.ai/blog/glm-5-3-released-specs-benchmarks-api)
- [What is GLM 5.3 — geotoolbox](https://geotoolbox.ai/blog/what-is-glm-5-3)
- [Kimi K3 — Analytics Vidhya](https://www.analyticsvidhya.com/?p=256969)
- [Kimi K3 review — techsy.io](https://techsy.io/en/blog/kimi-k3-review)
- [DeepSeek V4 — DataCamp](https://www.datacamp.com/blog/deepseek-v4)
- [DeepSeek V4 matches frontier models — Let's Data Science](https://letsdatascience.com/blog/deepseek-v4-matches-frontier-models-fraction-cost)
- [DeepSeek V4.1-Flash-1017 — SmartScope](https://smartscope.blog/en/blog/deepseek-v4-1-flash-1017-release-benchmarks-price-2026/)
- [DeepSeek V4.1-Flash-1017 — MindStudio](https://www.mindstudio.ai/blog/deepseek-v4-1-flash-1017-release)
- [DeepSeek launches V4.1-Flash and retires V4-Pro — The Next Web](https://thenextweb.com/news/deepseek-v4-1-flash-launch-v4-pro-retired-price-cut)
- [NVIDIA Debuts Nemotron 3 Family — NVIDIA Newsroom](https://nvidianews.nvidia.com/news/nvidia-debuts-nemotron-3-family-of-open-models)
- [NVIDIA Computex 2026 recap — ExplainX](https://explainx.ai/blog/nvidia-computex-2026-nemotron-3-ultra-complete-recap)
- [Nemotron — Wikipedia](https://en.wikipedia.org/wiki/Nemotron)
- [Mistral Large 4 Open Weights — ShiftDelete](https://en.shiftdelete.net/mistral-large-4-open-weights/)
- [Mistral Large 4 im Test — eesel.ai](https://www.eesel.ai/de/blog/mistral-large-4-test)
- [Mistral Large — Artificial Analysis](https://artificialanalysis.ai/models/mistral-large)
- [Recent open weights model launches — Artificial Analysis](https://www.artificialanalysis.ai/articles/recent-open-weights-model-launches)
