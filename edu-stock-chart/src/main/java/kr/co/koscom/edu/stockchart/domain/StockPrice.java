package kr.co.koscom.edu.stockchart.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/** 종목별 일별 종가 */
@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class StockPrice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 12)
    private String symbol;

    @Column(nullable = false)
    private LocalDate tradeDate;

    @Column(nullable = false, precision = 15, scale = 2)
    private BigDecimal closePrice;

    public StockPrice(String symbol, LocalDate tradeDate, BigDecimal closePrice) {
        this.symbol = symbol;
        this.tradeDate = tradeDate;
        this.closePrice = closePrice;
    }
}
