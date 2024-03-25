package com.sc.sangchu.dto.consumer;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor
public class CommPopulationAgeDTO {
    private Long age10;
    private Long age20;
    private Long age30;
    private Long age40;
    private Long age50;
    private Long ageOver60;
    private final Long[] ageList = {age10, age20, age30, age40, age50, ageOver60};
}
