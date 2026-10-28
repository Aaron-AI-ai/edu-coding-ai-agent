# M9 실습 과제 1 — 실시간 차트 순위 필터·정렬 API

대시보드 순위 표 위의 **전체 / 국내 / 해외**, **코스콤증권 거래대금 / 급상승 / 급하락** 버튼이 실제로 동작하게 만든다.
화면(`edu-stock-chart-ui`)과 데이터(`data.sql`)는 준비되어 있다. **Spring Boot API 만 구현한다.**

## 지금 상태

- 화면은 버튼을 누르면 이미 아래처럼 호출한다. 서버가 파라미터를 무시해서 결과가 바뀌지 않는다.
  ```
  GET /api/dashboard/rankings?market=DOMESTIC&sort=RISE
  ```
- `stock_ranking` 테이블에 `overseas`(해외 여부) · `change_rate`(등락률) 컬럼과 17개 종목(국내 7 · 해외 10)이 들어 있다.
- `코스콤증권 거래량` · `거래대금` · `거래량` · `실시간` 버튼은 과제 범위가 아니다 (눌림 표시만 바뀐다).

## 요구사항

`GET /api/dashboard/rankings`

| 파라미터 | 값 | 생략 시 | 동작 |
|---|---|---|---|
| `market` | `ALL` · `DOMESTIC` · `OVERSEAS` | `ALL` | `DOMESTIC` 은 국내(`overseas = false`)만, `OVERSEAS` 는 해외만 |
| `sort` | `TRADE_AMOUNT` · `RISE` · `FALL` | `TRADE_AMOUNT` | `TRADE_AMOUNT` 는 `rank_no` 오름차순, `RISE` 는 등락률 내림차순, `FALL` 은 등락률 오름차순. 등락률이 같으면 `rank_no` 오름차순 |

- 위 값 외의 `market` · `sort` (소문자 포함) → **400**
- 파라미터를 모두 생략하면 **지금과 같은 결과** (17개, `rank_no` 순)
- 응답 형식은 바꾸지 않는다. 순위 칸 번호는 화면이 목록 순서로 매기므로 `rankNo` 를 다시 매기지 않는다

## 지켜야 할 것

- Controller → Service → Mapper 계층을 지킨다. Controller 에서 Mapper 를 바로 부르지 않는다
- SQL 은 `DashboardMapper.xml` 에 둔다
- 이동평균 기능(`StockController` · `MovingAverageService`)은 건드리지 않는다

## 완료 기준

1. `./gradlew test` 가 통과한다 (기존 테스트 포함)
2. 위 요구사항 표의 각 행과 400 경우를 검증하는 테스트가 있다
3. `scripts/start.*` 로 띄운 화면에서 버튼을 눌렀을 때 순위가 바뀐다

## 확인용 예시 (시드 데이터 기준)

| 요청 | 기대 결과 |
|---|---|
| (파라미터 없음) | 17개, 1위 SOXL |
| `?market=DOMESTIC&sort=RISE` | 7개, 1위 코스모스바이오(+29.94%) · 2위 에코프로비엠(+7.81%) |
| `?market=OVERSEAS&sort=FALL` | 10개, 1위 SOXS(-2.11%) |
| `?market=KR` · `?sort=rise` | 400 |
