package kr.co.koscom.edu.stockchart.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/** 종목별 일별 종가 (stock_price 테이블) */
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class StockPrice {

    private Long id;
    private String symbol;
    private LocalDate tradeDate;
    private BigDecimal closePrice;

    public StockPrice(String symbol, LocalDate tradeDate, BigDecimal closePrice) {
        this.symbol = symbol;
        this.tradeDate = tradeDate;
        this.closePrice = closePrice;
    }
}
