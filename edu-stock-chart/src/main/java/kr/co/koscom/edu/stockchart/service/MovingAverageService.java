package kr.co.koscom.edu.stockchart.service;

import kr.co.koscom.edu.stockchart.domain.StockPrice;
import kr.co.koscom.edu.stockchart.dto.MovingAverageResponse;
import kr.co.koscom.edu.stockchart.dto.MovingAverageResponse.Point;
import kr.co.koscom.edu.stockchart.exception.StockNotFoundException;
import kr.co.koscom.edu.stockchart.repository.StockPriceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MovingAverageService {

    private final StockPriceRepository repository;

    /**
     * 종가의 단순 이동평균을 계산한다.
     * 데이터가 window 일보다 적으면 points 는 빈 목록이다.
     */
    public MovingAverageResponse calculate(String symbol, int window) {
        List<StockPrice> prices = repository.findBySymbolOrderByTradeDateAsc(symbol);
        if (prices.isEmpty()) {
            throw new StockNotFoundException(symbol);
        }

        List<Point> points = new ArrayList<>();
        for (int end = window - 1; end < prices.size(); end++) {
            BigDecimal sum = BigDecimal.ZERO;
            for (int i = end - window + 1; i <= end; i++) {
                sum = sum.add(prices.get(i).getClosePrice());
            }
            BigDecimal average = sum.divide(BigDecimal.valueOf(window), 2, RoundingMode.HALF_UP);
            points.add(new Point(prices.get(end).getTradeDate(), average));
        }
        return new MovingAverageResponse(symbol, window, points);
    }
}
