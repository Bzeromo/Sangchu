package com.sc.sangchu.dto.sales;

import com.fasterxml.jackson.databind.JsonNode;
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
    private Double weekDaySales;
    private Double weekendSales;
}
