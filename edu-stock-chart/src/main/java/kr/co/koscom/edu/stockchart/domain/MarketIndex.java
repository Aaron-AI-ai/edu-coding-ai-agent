package kr.co.koscom.edu.stockchart.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/** 대시보드 지수·환율·코인 (market_index 테이블). price 가 null 이면 '실시간 시세 보기' */
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class MarketIndex {

    private String code;
    private String name;
    private String tag;          // 쉼표 구분
    private boolean tagHot;
    private BigDecimal price;
    private BigDecimal changeAmount;
    private BigDecimal changeRate;
    private BigDecimal high52w;
    private BigDecimal low52w;
    private String sparkline;    // 쉼표 구분
    private boolean onBoard;
    private boolean onTicker;
}
