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
@Table(name = "comm_income_tb")
public class CommIncomeEntity {

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

    //월 평균 소득
    @Column(name = "monthly_average_income_amount")
    private Double monthlyAverageIncomeAmount;

    //총 지출
    @Column(name = "expenditure_total_amount")
    private Double expenditureTotalAmount;

}
