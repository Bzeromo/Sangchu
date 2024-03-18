package com.sc.sangchu.postgresql.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.*;

@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Entity
@Table(name = "comm_store_tb")
public class CommStoreEntity {
    @Id
    @Column(name = "id")
    private Integer id;

    //년분기 코드
    @Column(name = "year_quarter_code")
    private String yearQuarterCode;

    //상권 코드
    @Column(name = "commercial_district_code")
    private Long commercialDistrictCode;

    //상권 코드 명
    @Column(name = "commercial_district_name")
    private String commercialDistrictName;

    //서비스 업종 코드
    @Column(name = "service_code")
    private String serviceCode;

    //서비스 업종 코드 명
    @Column(name = "service_name")
    private String serviceName;

    //대분류 코드
    @Column(name = "major_category_code")
    private String majorCategoryCode;

    //대분류 코드 명
    @Column(name = "major_category_code_name")
    private String majorCategoryName;

    //중분류 코드
    @Column(name = "middle_category_code")
    private String middleCategoryCode;

    //중분류 코드 명
    @Column(name = "middle_category_code_name")
    private String middleCategoryName;

    //점포 수
    @Column(name = "store_count")
    private Long storeCount;

    //프랜차이즈 수
    @Column(name = "franchise_store_count")
    private Long franchiseStoreCount;

}
