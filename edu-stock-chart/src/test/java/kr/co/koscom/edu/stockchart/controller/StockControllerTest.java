package kr.co.koscom.edu.stockchart.controller;

import kr.co.koscom.edu.stockchart.dto.MovingAverageResponse;
import kr.co.koscom.edu.stockchart.dto.MovingAverageResponse.Point;
import kr.co.koscom.edu.stockchart.exception.StockNotFoundException;
import kr.co.koscom.edu.stockchart.service.MovingAverageService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(StockController.class)
class StockControllerTest {

    @Autowired
    MockMvc mockMvc;

    @MockitoBean
    MovingAverageService service;

    @Test
    @DisplayName("window 를 생략하면 5일 이동평균을 조회한다")
    void defaultWindow() throws Exception {
        when(service.calculate("005930", 5)).thenReturn(new MovingAverageResponse("005930", 5,
                List.of(new Point(LocalDate.of(2026, 9, 7), new BigDecimal("70700.00")))));

        mockMvc.perform(get("/api/stocks/005930/moving-average"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.symbol").value("005930"))
                .andExpect(jsonPath("$.window").value(5))
                .andExpect(jsonPath("$.points[0].date").value("2026-09-07"))
                .andExpect(jsonPath("$.points[0].value").value(70700.00));
    }

    @Test
    @DisplayName("window 가 범위(2~20)를 벗어나면 400")
    void invalidWindow() throws Exception {
        mockMvc.perform(get("/api/stocks/005930/moving-average").param("window", "1"))
                .andExpect(status().isBadRequest());
        mockMvc.perform(get("/api/stocks/005930/moving-average").param("window", "21"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("없는 종목이면 404")
    void unknownSymbol() throws Exception {
        when(service.calculate(anyString(), anyInt())).thenThrow(new StockNotFoundException("000000"));

        mockMvc.perform(get("/api/stocks/000000/moving-average"))
                .andExpect(status().isNotFound());
    }
}
