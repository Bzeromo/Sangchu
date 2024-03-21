package com.sc.sangchu.postgresql.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Entity
@Table(name = "commercial_district_tb")
public class CommDistEntity {

    @Id
    @Column(name= "commercial_district_code")
    private Long commercialDistrictCode;

    @Column(name= "commercial_district_name")
    private String commercialDistrictName;

    //위도 경도
    @Column(name = "latitude")
    private Double latitude;

    @Column(name= "longitude")
    private Double longitude;

    //자치구
    @Column(name= "gu_code")
    private Long guCode;

    @Column(name= "gu_name")
    private String guName;

    //행정동
    @Column(name= "dong_code")
    private Long dongCode;

    @Column(name= "dong_name")
    private String dongName;

    //면적
    @Column(name= "area_size")
    private Long areaSize;

    // 상권 점수
    @Column(name= "commercial_district_score")
    private Double commercialDistrictScore;

    // 면적당 상권 전체 매출 점수
    @Column(name= "sales_score")
    private Double salesScore;

    // 상주인구 점수
    @Column(name= "resident_population_score")
    private Double residentPopulationScore;

    // 유동인구 점수
    @Column(name= "floating_population_score")
    private Double floatingPopulationScore;

    // 업종다양성 점수
    @Column(name= "rdi_score")
    private Double rdiScore;
}
