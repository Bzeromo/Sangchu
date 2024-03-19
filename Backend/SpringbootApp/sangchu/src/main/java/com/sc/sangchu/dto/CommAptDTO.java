package com.sc.sangchu.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommAptDTO {
    private Long apartmentComplexes;
    private Long aptAvgArea;
    private Long aptAvgPrice;
}