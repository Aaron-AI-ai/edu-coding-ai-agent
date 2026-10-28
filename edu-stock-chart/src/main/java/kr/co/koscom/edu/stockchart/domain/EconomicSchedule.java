package kr.co.koscom.edu.stockchart.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/** 대시보드 주요 일정 (economic_schedule 테이블) */
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class EconomicSchedule {

    private Long id;
    private LocalDate scheduleDate;
    private String title;
}
