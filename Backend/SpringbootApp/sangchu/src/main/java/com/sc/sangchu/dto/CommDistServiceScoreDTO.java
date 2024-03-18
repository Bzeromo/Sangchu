package com.sc.sangchu.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CommDistServiceScoreDTO {
    private Long id;
    private Long commercialDistrictCode;
    private String commercialDistrictName;
    private Double serviceCode;
    private Double serviceCodeName;
    private Long serviceBigCategory;
    private String serviceBigCategoryName;
    private Long serviceMcategory;
    private Long serviceMcategoryName;
    private String salesScore;
    private Long storeDensityScore;
}
