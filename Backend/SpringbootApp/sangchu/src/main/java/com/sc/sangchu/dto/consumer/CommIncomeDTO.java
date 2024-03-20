package com.sc.sangchu.dto.consumer;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommIncomeDTO {
    private Double seoulAllAverageIncome;
    private Double monthlyAverageIncome;
    private Double expenditureTotal;
}
