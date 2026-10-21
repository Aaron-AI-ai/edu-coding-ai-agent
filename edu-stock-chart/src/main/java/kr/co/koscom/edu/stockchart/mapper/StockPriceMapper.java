package kr.co.koscom.edu.stockchart.mapper;

import kr.co.koscom.edu.stockchart.domain.StockPrice;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/** SQL 은 resources/mapper/StockPriceMapper.xml */
@Mapper
public interface StockPriceMapper {

    /** 종목의 일별 종가를 거래일 오름차순으로 조회한다. 없으면 빈 목록 */
    List<StockPrice> findBySymbol(String symbol);
}
