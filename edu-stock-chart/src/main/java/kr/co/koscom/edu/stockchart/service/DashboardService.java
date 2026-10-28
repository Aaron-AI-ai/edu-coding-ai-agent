package kr.co.koscom.edu.stockchart.service;

import kr.co.koscom.edu.stockchart.domain.EconomicSchedule;
import kr.co.koscom.edu.stockchart.domain.MarketIndex;
import kr.co.koscom.edu.stockchart.domain.StockRanking;
import kr.co.koscom.edu.stockchart.mapper.DashboardMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DashboardService {

    private final DashboardMapper mapper;

    /** 카드 · 티커에 쓰는 지수 전체를 표시 순서대로 */
    public List<MarketIndex> getIndices() {
        return mapper.findIndices();
    }

    public List<EconomicSchedule> getSchedules() {
        return mapper.findSchedules();
    }

    /** 순위 오름차순 */
    public List<StockRanking> getRankings() {
        return mapper.findRankings();
    }
}
