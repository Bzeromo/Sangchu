package com.sc.sangchu.dto.infra;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommStoreTotalCountDTO {
    private Long commCode;
    private Long totalStoreCount;
}
