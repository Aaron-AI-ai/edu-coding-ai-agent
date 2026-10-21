-- 종목별 일별 종가 (H2 인메모리 · 앱을 켤 때마다 새로 만든다)
CREATE TABLE IF NOT EXISTS stock_price (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    symbol      VARCHAR(12)    NOT NULL,
    trade_date  DATE           NOT NULL,
    close_price DECIMAL(15, 2) NOT NULL
);
