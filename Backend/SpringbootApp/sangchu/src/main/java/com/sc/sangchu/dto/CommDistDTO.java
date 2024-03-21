package com.sc.sangchu.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommDistDTO {
    private String commercialDistrictName;
    private Double latitude;
    private Double longitude;
    private Long guCode;
    private String guName;
    private Long dongCode;
    private String dongName;
    private Long areaSize;
    private Double commercialDistrictScore;
    private Double salesScore;
    private Double residentPopulationScore;
    private Double floatingPopulationScore;
    private Double rdiScore;
}
