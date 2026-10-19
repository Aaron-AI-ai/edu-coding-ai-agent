package kr.co.koscom.edu.stockchart.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record MovingAverageResponse(String symbol, int window, List<Point> points) {

    public record Point(LocalDate date, BigDecimal value) {
    }
}
