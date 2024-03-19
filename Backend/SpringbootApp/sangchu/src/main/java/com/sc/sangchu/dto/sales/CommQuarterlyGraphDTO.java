package com.sc.sangchu.dto.sales;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@Builder
@NoArgsConstructor
public class CommQuarterlyGraphDTO {
    private Integer year;
    private Integer quarter;
    private Double WeekDaySales;
    private Double WeekendSales;
}
