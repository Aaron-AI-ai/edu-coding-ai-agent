package kr.co.koscom.edu.stockchart.repository;

import kr.co.koscom.edu.stockchart.domain.StockPrice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface StockPriceRepository extends JpaRepository<StockPrice, Long> {

    List<StockPrice> findBySymbolOrderByTradeDateAsc(String symbol);
}
