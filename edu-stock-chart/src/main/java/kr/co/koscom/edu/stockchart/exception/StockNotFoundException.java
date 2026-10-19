package kr.co.koscom.edu.stockchart.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class StockNotFoundException extends RuntimeException {

    public StockNotFoundException(String symbol) {
        super("종목을 찾을 수 없습니다: " + symbol);
    }
}
