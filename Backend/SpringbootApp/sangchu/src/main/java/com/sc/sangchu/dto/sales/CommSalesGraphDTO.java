package com.sc.sangchu.dto.sales;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CommSalesGraphDTO {
    private Integer year;
    private String commDistrictName;
    private Long[] salesCount;
    private Double[] sales;
}
