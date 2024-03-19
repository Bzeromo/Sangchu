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
@Table(name = "comm_working_population_tb")
public class CommWorkingPopulationEntity {

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

    //총 직장인구 수
    @Column(name = "total_working_population")
    private Long totalWorkingPopulation;

    //남성 10대 직장인구 수
    @Column(name = "male_age_10_working_population")
    private Long maleAge10WorkingPopulation;

    //남성 20대 직장인구 수
    @Column(name = "male_age_20_working_population")
    private Long maleAge20WorkingPopulation;

    //남성 30대 직장인구 수
    @Column(name = "male_age_30_working_population")
    private Long maleAge30WorkingPopulation;

    //남성 40대 직장인구 수
    @Column(name = "male_age_40_working_population")
    private Long maleAge40WorkingPopulation;

    //남성 50대 직장인구 수
    @Column(name = "male_age_50_working_population")
    private Long maleAge50WorkingPopulation;

    //남성 60대 이상 직장인구 수
    @Column(name = "male_age_over_60_working_population")
    private Long maleAgeOver60WorkingPopulation;

    //여성 10대 직장인구 수
    @Column(name = "female_age_10_working_population")
    private Long femaleAge10WorkingPopulation;

    //여성 20대 직장인구 수
    @Column(name = "female_age_20_working_population")
    private Long femaleAge20WorkingPopulation;

    //여성 30대 직장인구 수
    @Column(name = "female_age_30_working_population")
    private Long femaleAge30WorkingPopulation;

    //여성 40대 직장인구 수
    @Column(name = "female_age_40_working_population")
    private Long femaleAge40WorkingPopulation;

    //여성 50대 직장인구 수
    @Column(name = "female_age_50_working_population")
    private Long femaleAge50WorkingPopulation;

    //여성 60대 이상 직장인구 수
    @Column(name = "female_age_over_60_working_population")
    private Long femaleAgeOver60WorkingPopulation;
}
