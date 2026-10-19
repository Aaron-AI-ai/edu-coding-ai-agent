package kr.co.koscom.edu.stockchart.service;

import kr.co.koscom.edu.stockchart.domain.StockPrice;
import kr.co.koscom.edu.stockchart.dto.MovingAverageResponse;
import kr.co.koscom.edu.stockchart.dto.MovingAverageResponse.Point;
import kr.co.koscom.edu.stockchart.exception.StockNotFoundException;
import kr.co.koscom.edu.stockchart.repository.StockPriceRepository;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class MovingAverageService {

    private static final int MAX_RETRY = 3;
    private static final long RETRY_DELAY_MS = 100L;
    private static final int MIN_WINDOW = 2;
    private static final int MAX_WINDOW = 20;

    private final StockPriceRepository repository;

    private final Map<String, MovingAverageResponse> cache = new ConcurrentHashMap<>();
    private final MovingAverageConfig config = MovingAverageConfig.builder()
            .scale(2)
            .roundingMode(RoundingMode.HALF_UP)
            .build();
    private final AverageStrategyFactory strategyFactory = new AverageStrategyFactory();

    /**
     * 종가의 단순 이동평균을 계산한다.
     * 데이터가 window 일보다 적으면 points 는 빈 목록이다.
     */
    public MovingAverageResponse calculate(String symbol, int window) {
        long startedAt = System.nanoTime();
        validateSymbol(symbol);
        validateWindow(window);

        String cacheKey = CacheKeyBuilder.of(symbol, window);
        if (cache.containsKey(cacheKey)) {
            log.debug("cache hit: {}", cacheKey);
            return cache.get(cacheKey);
        }

        List<StockPrice> prices = fetchWithRetry(symbol);
        if (prices == null || prices.size() == 0) {
            throw new StockNotFoundException(symbol);
        }

        List<BigDecimal> closePrices = new ArrayList<>();
        for (StockPrice price : prices) {
            closePrices.add(price.getClosePrice());
        }

        AverageStrategy strategy = strategyFactory.create(AverageType.SIMPLE);
        List<Point> points = new ArrayList<>();
        for (int end = window - 1; end < closePrices.size(); end++) {
            List<BigDecimal> slice = new ArrayList<>();
            for (int i = end - window + 1; i <= end; i++) {
                slice.add(closePrices.get(i));
            }
            BigDecimal average = strategy.average(slice, config);
            points.add(new Point(prices.get(end).getTradeDate(), average));
        }

        MovingAverageResponse response = new MovingAverageResponse(
                symbol, window, Collections.unmodifiableList(new ArrayList<>(points)));
        cache.put(cacheKey, response);
        log.debug("calculate {} took {} ms", cacheKey, (System.nanoTime() - startedAt) / 1_000_000);
        return response;
    }

    private void validateSymbol(String symbol) {
        if (symbol == null || symbol.trim().isEmpty()) {
            throw new IllegalArgumentException("symbol 은 필수입니다");
        }
    }

    private void validateWindow(int window) {
        if (window < MIN_WINDOW || window > MAX_WINDOW) {
            throw new IllegalArgumentException("window 는 " + MIN_WINDOW + "~" + MAX_WINDOW + " 사이여야 합니다: " + window);
        }
    }

    private List<StockPrice> fetchWithRetry(String symbol) {
        RuntimeException lastError = null;
        for (int attempt = 1; attempt <= MAX_RETRY; attempt++) {
            try {
                return repository.findBySymbolOrderByTradeDateAsc(symbol);
            } catch (RuntimeException e) {
                lastError = e;
                log.warn("시세 조회 실패 ({}/{}): {}", attempt, MAX_RETRY, e.getMessage());
                try {
                    Thread.sleep(RETRY_DELAY_MS);
                } catch (InterruptedException ie) {
                    Thread.currentThread().interrupt();
                    throw e;
                }
            }
        }
        throw lastError;
    }

    enum AverageType {
        SIMPLE
    }

    interface AverageStrategy {
        BigDecimal average(List<BigDecimal> values, MovingAverageConfig config);
    }

    static class SimpleAverageStrategy implements AverageStrategy {

        @Override
        public BigDecimal average(List<BigDecimal> values, MovingAverageConfig config) {
            BigDecimal sum = BigDecimal.ZERO;
            for (BigDecimal value : values) {
                sum = sum.add(value);
            }
            return sum.divide(BigDecimal.valueOf(values.size()), config.getScale(), config.getRoundingMode());
        }
    }

    static class AverageStrategyFactory {

        AverageStrategy create(AverageType type) {
            switch (type) {
                case SIMPLE:
                    return new SimpleAverageStrategy();
                default:
                    throw new UnsupportedOperationException("지원하지 않는 평균 방식: " + type);
            }
        }
    }

    @Getter
    @Builder
    static class MovingAverageConfig {
        private final int scale;
        private final RoundingMode roundingMode;
    }

    static final class CacheKeyBuilder {

        private CacheKeyBuilder() {
        }

        static String of(String symbol, int window) {
            return new StringBuilder().append(symbol).append(":").append(window).toString();
        }
    }
}
