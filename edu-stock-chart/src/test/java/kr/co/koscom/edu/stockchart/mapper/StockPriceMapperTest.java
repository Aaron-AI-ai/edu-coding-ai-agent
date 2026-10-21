package kr.co.koscom.edu.stockchart.mapper;

import kr.co.koscom.edu.stockchart.domain.StockPrice;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mybatis.spring.boot.test.autoconfigure.MybatisTest;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/** schema.sql · data.sql 이 들어간 H2 에서 실제 SQL 을 실행한다 */
@MybatisTest
class StockPriceMapperTest {

    @Autowired
    StockPriceMapper mapper;

    @Test
    @DisplayName("종목의 종가를 거래일 오름차순으로 가져오고 컬럼이 필드에 매핑된다")
    void findBySymbol() {
        List<StockPrice> prices = mapper.findBySymbol("005930");

        assertThat(prices).hasSize(10);
        assertThat(prices).extracting(StockPrice::getTradeDate).isSorted();
        assertThat(prices.get(0).getId()).isNotNull();
        assertThat(prices.get(0).getTradeDate()).isEqualTo(LocalDate.of(2026, 9, 1));
        assertThat(prices.get(0).getClosePrice()).isEqualByComparingTo("70100.00");
    }

    @Test
    @DisplayName("없는 종목이면 빈 목록을 돌려준다")
    void unknownSymbol() {
        assertThat(mapper.findBySymbol("000000")).isEmpty();
    }
}
