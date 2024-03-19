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
@Table(name = "comm_resident_population_tb")
public class CommResidentPopulationEntity {

    @Id
    @Column(name = "id")
    private Integer id;

    //년도
    @Column(name = "year_code")
    private Integer yearCode;

    //분기
    @Column(name = "quarter_code")
    private Integer quarterCode;

    //상권 코드
    @Column(name = "commercial_district_code")
    private Long commercialDistrictCode;

    //상권 코드 명
    @Column(name = "commercial_district_name")
    private String commercialDistrictName;

    //총 상주인구 수
    @Column(name = "total_resident_population")
    private Long totalResidentPopulation;

    //총 가구 수
    @Column(name = "total_household")
    private Long totalHousehold;

    //남성 10대 상주인구 수
    @Column(name = "male_age_10_resident_population")
    private Long maleAge10ResidentPopulation;

    //남성 20대 상주인구 수
    @Column(name = "male_age_20_resident_population")
    private Long maleAge20ResidentPopulation;

    //남성 30대 상주인구 수
    @Column(name = "male_age_30_resident_population")
    private Long maleAge30ResidentPopulation;

    //남성 40대 상주인구 수
    @Column(name = "male_age_40_resident_population")
    private Long maleAge40ResidentPopulation;

    //남성 50대 상주인구 수
    @Column(name = "male_age_50_resident_population")
    private Long maleAge50ResidentPopulation;

    //남성 60대 이상 상주인구 수
    @Column(name = "male_age_over_60_resident_population")
    private Long maleAgeOver60ResidentPopulation;

    //여성 10대 상주인구 수
    @Column(name = "female_age_10_resident_population")
    private Long femaleAge10ResidentPopulation;

    //여성 20대 상주인구 수
    @Column(name = "female_age_20_resident_population")
    private Long femaleAge20ResidentPopulation;

    //여성 30대 상주인구 수
    @Column(name = "female_age_30_resident_population")
    private Long femaleAge30ResidentPopulation;

    //여성 40대 상주인구 수
    @Column(name = "female_age_40_resident_population")
    private Long femaleAge40ResidentPopulation;

    //여성 50대 상주인구 수
    @Column(name = "female_age_50_resident_population")
    private Long femaleAge50ResidentPopulation;

    //여성 60대 이상 상주인구 수
    @Column(name = "female_age_over_60_resident_population")
    private Long femaleAgeOver60ResidentPopulation;

}
