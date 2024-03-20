package com.sc.sangchu.dto.infra;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CommFacilitiesDTO {
    private Long facilities;
    private Double bus;
    private Double culTouristFacilities;
    private Double educationalFacilities;
    private Double trainSubway;
}
