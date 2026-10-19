package kr.co.koscom.edu.stockchart.service;

import kr.co.koscom.edu.stockchart.domain.StockPrice;
import kr.co.koscom.edu.stockchart.dto.MovingAverageResponse;
import kr.co.koscom.edu.stockchart.exception.StockNotFoundException;
import kr.co.koscom.edu.stockchart.repository.StockPriceRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class MovingAverageServiceTest {

    @Mock
    StockPriceRepository repository;

    @InjectMocks
    MovingAverageService service;

    private StockPrice price(int day, String close) {
        return new StockPrice("005930", LocalDate.of(2026, 9, day), new BigDecimal(close));
    }

    @Test
    @DisplayName("3일 이동평균은 3일째부터 한 칸씩 이동하며 계산된다")
    void movingAverageOfThree() {
        when(repository.findBySymbolOrderByTradeDateAsc("005930"))
                .thenReturn(List.of(price(1, "10"), price(2, "20"), price(3, "30"), price(4, "40")));

        MovingAverageResponse result = service.calculate("005930", 3);

        assertThat(result.points()).hasSize(2);
        assertThat(result.points().get(0).date()).isEqualTo(LocalDate.of(2026, 9, 3));
        assertThat(result.points().get(0).value()).isEqualByComparingTo("20.00");
        assertThat(result.points().get(1).value()).isEqualByComparingTo("30.00");
    }

    @Test
    @DisplayName("소수점 셋째 자리에서 반올림한다")
    void roundsToTwoDecimals() {
        when(repository.findBySymbolOrderByTradeDateAsc("005930"))
                .thenReturn(List.of(price(1, "10"), price(2, "10"), price(3, "11")));

        MovingAverageResponse result = service.calculate("005930", 3);

        assertThat(result.points().get(0).value()).isEqualByComparingTo("10.33");
    }

    @Test
    @DisplayName("데이터가 window 보다 적으면 빈 목록을 돌려준다")
    void windowLargerThanData() {
        when(repository.findBySymbolOrderByTradeDateAsc("005930"))
                .thenReturn(List.of(price(1, "10"), price(2, "20")));

        assertThat(service.calculate("005930", 5).points()).isEmpty();
    }

    @Test
    @DisplayName("없는 종목이면 StockNotFoundException 이 발생한다")
    void unknownSymbol() {
        when(repository.findBySymbolOrderByTradeDateAsc("000000")).thenReturn(List.of());

        assertThatThrownBy(() -> service.calculate("000000", 5))
                .isInstanceOf(StockNotFoundException.class);
    }
}
