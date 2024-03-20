package com.sc.sangchu.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommIndicatorDTO {
    private String RDI;
    private String indicator;
}