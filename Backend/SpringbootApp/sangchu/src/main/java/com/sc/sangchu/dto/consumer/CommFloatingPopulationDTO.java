package com.sc.sangchu.dto.consumer;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommFloatingPopulationDTO {
    private JsonNode age;
    private JsonNode time;
    private JsonNode day;
    private JsonNode quarterlyTrends;
}
