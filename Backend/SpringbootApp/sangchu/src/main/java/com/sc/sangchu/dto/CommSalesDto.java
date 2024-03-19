package com.sc.sangchu.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommSalesDto {
    //월평균, 주중, 주말 매출 금액
    private Double MonthlySales;
    private Double WeekDaySales;
    private Double WeekendSales;
}
