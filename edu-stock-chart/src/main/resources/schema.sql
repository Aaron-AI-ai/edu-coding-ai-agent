-- 종목별 일별 종가 (H2 인메모리 · 앱을 켤 때마다 새로 만든다)
CREATE TABLE IF NOT EXISTS stock_price (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    symbol      VARCHAR(12)    NOT NULL,
    trade_date  DATE           NOT NULL,
    close_price DECIMAL(15, 2) NOT NULL
);

-- 출납 계좌 (스킬 실습 1 · 계좌 잔고 조회 API 용)
CREATE TABLE IF NOT EXISTS account (
    account_no VARCHAR(20)    PRIMARY KEY,
    owner_name VARCHAR(50)    NOT NULL,
    balance    DECIMAL(15, 2) NOT NULL DEFAULT 0,
    updated_at TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 대시보드: 지수·환율·코인 카드 + 하단 티커
-- tag · sparkline 은 쉼표 구분, tag_hot 이면 첫 태그를 강조
CREATE TABLE IF NOT EXISTS market_index (
    code          VARCHAR(20)    PRIMARY KEY,
    name          VARCHAR(50)    NOT NULL,
    tag           VARCHAR(50),
    tag_hot       BOOLEAN        NOT NULL DEFAULT FALSE,
    price         DECIMAL(18, 2),
    change_amount DECIMAL(18, 2),
    change_rate   DECIMAL(6, 2),
    high_52w      DECIMAL(18, 2),
    low_52w       DECIMAL(18, 2),
    sparkline     VARCHAR(500),
    on_board      BOOLEAN        NOT NULL DEFAULT TRUE,
    on_ticker     BOOLEAN        NOT NULL DEFAULT FALSE,
    sort_order    INT            NOT NULL
);

-- 대시보드: 주요 일정
CREATE TABLE IF NOT EXISTS economic_schedule (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    schedule_date DATE           NOT NULL,
    title         VARCHAR(100)   NOT NULL
);

-- 대시보드: 실시간 차트 (코스콤증권 거래대금 순위) · 금액 단위는 원, 거래대금·시가총액은 억원
CREATE TABLE IF NOT EXISTS stock_ranking (
    rank_no       INT            PRIMARY KEY,
    symbol        VARCHAR(20)    NOT NULL,
    name          VARCHAR(50)    NOT NULL,
    logo_text     VARCHAR(10),
    logo_color    VARCHAR(10),
    overseas      BOOLEAN        NOT NULL,
    price         BIGINT         NOT NULL,
    change_rate   DECIMAL(6, 2)  NOT NULL,
    trade_amount  BIGINT         NOT NULL,
    market_cap    BIGINT         NOT NULL,
    buy_ratio     INT            NOT NULL,
    industry      VARCHAR(30),
    ai_summary    VARCHAR(100)
);

-- 종목 마스터 (루프 실습 · 종목 검색 API 용)
CREATE TABLE IF NOT EXISTS stock (
    symbol        VARCHAR(20)    PRIMARY KEY,
    name          VARCHAR(50)    NOT NULL,
    market        VARCHAR(10)    NOT NULL   -- KOSPI · KOSDAQ · NASDAQ · NYSE
);
