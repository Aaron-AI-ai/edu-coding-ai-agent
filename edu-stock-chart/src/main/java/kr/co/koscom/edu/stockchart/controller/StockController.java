package kr.co.koscom.edu.stockchart.controller;

import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import kr.co.koscom.edu.stockchart.dto.MovingAverageResponse;
import kr.co.koscom.edu.stockchart.service.MovingAverageService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/stocks")
@RequiredArgsConstructor
public class StockController {

    private final MovingAverageService movingAverageService;

    @Operation(summary = "종가 이동평균 조회", description = "window 일 단순 이동평균. window 는 2~20, 기본 5")
    @GetMapping("/{symbol}/moving-average")
    public MovingAverageResponse movingAverage(
            @PathVariable String symbol,
            @RequestParam(defaultValue = "5") @Min(2) @Max(20) int window) {
        return movingAverageService.calculate(symbol, window);
    }
}
