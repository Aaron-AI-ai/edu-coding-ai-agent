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
