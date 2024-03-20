package com.sc.sangchu.dto.infra;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommStoreDTO {
    private JsonNode storeGraph;
}
