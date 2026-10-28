package kr.co.koscom.edu.stockchart.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/** 대시보드 실시간 차트 순위 (stock_ranking 테이블). tradeAmount · marketCap 은 억원 */
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class StockRanking {

    private int rankNo;
    private String symbol;
    private String name;
    private String logoText;
    private String logoColor;
    private boolean overseas;
    private long price;
    private BigDecimal changeRate;
    private long tradeAmount;
    private long marketCap;
    private int buyRatio;
    private String industry;
    private String aiSummary;
}
