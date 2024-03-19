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
@Table(name = "comm_apartment_tb")
public class CommAptEntity {

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

    //총 세대수
    @Column(name = "apartment_complexes")
    private Long apartmentComplexes;

    //20평 미만 세대수
    @Column(name = "household_under_20_pyeong")
    private Double householdUnder20Pyeong;

    //20평~30평 세대수
    @Column(name = "household_20_to_30_pyeong")
    private Double household20To30Pyeong;

    //30평~40평 세대수
    @Column(name = "household_30_to_40_pyeong")
    private Double household30To40Pyeong;

    //40평~50평 세대수
    @Column(name = "household_40_to_50_pyeong")
    private Double household40To50Pyeong;

    //50평 이상 세대수
    @Column(name = "household_over_50_pyeong")
    private Double householdOver50Pyeong;

    //1억 미만 세대수
    @Column(name = "household_less_than_100_million_price")
    private Double householdLessThan100MillionPrice;

    //1억 ~ 2억 세대수
    @Column(name = "household_100_million_to_200_million_price")
    private Double household100To200MillionPrice;

    //2억 ~ 3억 세대수
    @Column(name = "household_200_million_to_300_million_price")
    private Double household200To300MillionPrice;

    //3억 ~ 4억 세대수
    @Column(name = "household_300_million_to_400_million_price")
    private Double household300To400MillionPrice;

    //4억 ~ 5억 세대수
    @Column(name = "household_400_million_to_500_million_price")
    private Double household400To500MillionPrice;

    //5억 ~ 6억 세대수
    @Column(name = "household_500_million_to_600_million_price")
    private Double household500To600MillionPrice;

    //6억 이상 세대수
    @Column(name = "household_over_than_600_million_price")
    private Double householdOverThan600MillionPrice;

    @Column(name = "apartment_avg_area")
    private Long aptAvgArea;

    @Column(name = "apartment_avg_price")
    private Long aptAvgPrice;

}
