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
@Table(name = "commercial_district_service_tb")
public class CommDistServiceScoreEntity {

    @Id
    @Column(name= "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 상권 코드
    @Column(name= "commercial_district_code")
    private Long commercialDistrictCode;

    // 상권 코드 명
    @Column(name= "commercial_district_name")
    private String commercialDistrictName;

    // 서비스 업종 코드
    @Column(name = "service_code")
    private Double serviceCode;

    // 서비스 업종 코드명
    @Column(name= "service_code_name")
    private Double serviceCodeName;

    // 업종대분류
    @Column(name= "service_big_category")
    private Long serviceBigCategory;

    // 업종대분류명
    @Column(name = "service_big_category_name")
    private String serviceBigCategoryName;

    // 업종중분류
    @Column(name= "service_mcategory")
    private Long serviceMcategory;

    // 업종중분류명
    @Column(name= "service_mcategory_name")
    private Long serviceMcategoryName;

    // 해당업종매출점수
    @Column(name= "sales_score")
    private String salesScore;

    // 해당업종점포밀도점수
    @Column(name= "store_density_score")
    private Long storeDensityScore;
}

