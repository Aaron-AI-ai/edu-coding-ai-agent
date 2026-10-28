package kr.co.koscom.edu.stockchart.controller;

import io.swagger.v3.oas.annotations.Operation;
import kr.co.koscom.edu.stockchart.domain.EconomicSchedule;
import kr.co.koscom.edu.stockchart.domain.MarketIndex;
import kr.co.koscom.edu.stockchart.domain.StockRanking;
import kr.co.koscom.edu.stockchart.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    @Operation(summary = "지수·환율·코인", description = "onBoard 는 상단 카드, onTicker 는 하단 티커")
    @GetMapping("/indices")
    public List<MarketIndex> indices() {
        return dashboardService.getIndices();
    }

    @Operation(summary = "주요 일정")
    @GetMapping("/schedules")
    public List<EconomicSchedule> schedules() {
        return dashboardService.getSchedules();
    }

    @Operation(summary = "실시간 차트 순위", description = "코스콤증권 거래대금 순")
    @GetMapping("/rankings")
    public List<StockRanking> rankings() {
        return dashboardService.getRankings();
    }
}
