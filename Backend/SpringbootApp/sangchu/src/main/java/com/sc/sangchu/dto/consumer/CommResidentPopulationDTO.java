package com.sc.sangchu.dto.consumer;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommResidentPopulationDTO {
    private JsonNode genderAge;
    private JsonNode quarterlyTrends;
}
