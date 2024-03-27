package com.sc.sangchu.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommDistSetRankDTO {
    private Long commCode;
    private Long rank;
}
