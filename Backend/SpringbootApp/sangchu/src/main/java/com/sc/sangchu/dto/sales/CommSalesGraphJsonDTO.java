package com.sc.sangchu.dto.sales;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommSalesGraphJsonDTO {
    private JsonNode graphJson;
}