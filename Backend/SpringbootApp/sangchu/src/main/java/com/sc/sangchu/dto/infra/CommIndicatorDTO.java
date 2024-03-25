package com.sc.sangchu.dto.infra;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommIndicatorDTO {
    private String rdi;
    private String indicator;
}