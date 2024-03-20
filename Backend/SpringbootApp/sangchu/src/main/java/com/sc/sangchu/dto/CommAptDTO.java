package com.sc.sangchu.dto;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommAptDTO {
    private Long apartmentComplexes;
    private Long aptAvgArea;
    private Long aptAvgPrice;
    private JsonNode areaGraph;
    private JsonNode priceGraph;
}