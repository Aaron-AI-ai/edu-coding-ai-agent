# edu-stock-chart

교육용 주식 차트 API. 이 파일은 **세션마다 자동으로 읽히는 프로젝트 메모리** 예시다.

## 기술 스택
- Java 21 · Spring Boot 3.4 · MyBatis · H2 (인메모리) · springdoc(Swagger)
- 빌드: Gradle (`./gradlew`)

## 자주 쓰는 명령
- 테스트: `./gradlew test`
- 실행: `./gradlew bootRun` → http://localhost:8080 (Swagger: `/swagger-ui.html`)

## 패키지 구조 (`kr.co.koscom.edu.stockchart`)
- `controller` · `service` · `mapper` · `domain` · `dto` · `exception`
- SQL 은 `src/main/resources/mapper/*.xml`, 스키마 · 샘플 데이터는 `schema.sql` · `data.sql`
