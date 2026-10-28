package kr.co.koscom.edu.stockchart.mapper;

import kr.co.koscom.edu.stockchart.domain.EconomicSchedule;
import kr.co.koscom.edu.stockchart.domain.MarketIndex;
import kr.co.koscom.edu.stockchart.domain.StockRanking;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/** SQL 은 resources/mapper/DashboardMapper.xml */
@Mapper
public interface DashboardMapper {

    /** 카드 · 티커에 쓰는 지수 전체를 표시 순서대로 */
    List<MarketIndex> findIndices();

    List<EconomicSchedule> findSchedules();

    /** 순위 오름차순 */
    List<StockRanking> findRankings();
}
