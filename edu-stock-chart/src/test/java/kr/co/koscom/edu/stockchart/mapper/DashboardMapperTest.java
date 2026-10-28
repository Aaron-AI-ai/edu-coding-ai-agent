package kr.co.koscom.edu.stockchart.mapper;

import kr.co.koscom.edu.stockchart.domain.MarketIndex;
import kr.co.koscom.edu.stockchart.domain.StockRanking;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mybatis.spring.boot.test.autoconfigure.MybatisTest;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/** schema.sql · data.sql 이 들어간 H2 에서 실제 SQL 을 실행한다 */
@MybatisTest
class DashboardMapperTest {

    @Autowired
    DashboardMapper mapper;

    @Test
    @DisplayName("지수는 표시 순서대로, 컬럼이 필드에 매핑된다")
    void findIndices() {
        List<MarketIndex> indices = mapper.findIndices();

        assertThat(indices).hasSize(11);
        MarketIndex nasdaq = indices.get(1);
        assertThat(nasdaq.getCode()).isEqualTo("NASDAQ");
        assertThat(nasdaq.getHigh52w()).isEqualByComparingTo("26103.86");
        assertThat(nasdaq.isOnTicker()).isTrue();
    }

    @Test
    @DisplayName("주요 일정 3건")
    void findSchedules() {
        assertThat(mapper.findSchedules()).hasSize(3);
    }

    @Test
    @DisplayName("순위는 오름차순, 억원 단위 금액이 매핑된다")
    void findRankings() {
        List<StockRanking> rankings = mapper.findRankings();

        assertThat(rankings).extracting(StockRanking::getRankNo).isSorted();
        assertThat(rankings.get(0).getSymbol()).isEqualTo("SOXL");
        assertThat(rankings.get(0).getMarketCap()).isEqualTo(249000L);
        assertThat(rankings.get(0).getBuyRatio()).isEqualTo(46);
    }
}
