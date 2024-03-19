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
@Table(name = "comm_facilities_tb")
public class CommFacilitiesEntity {

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

    //집객 시설 수
    @Column(name = "facilities")
    private Long facilities;

    //버스 정류장 수
    @Column(name = "bus")
    private Double bus;

    //문화관광 수
    @Column(name = "cultural/tourist_facilities")
    private Double culTouristFacilities;

    //교육시설 수
    @Column(name = "educational_facilities")
    private Double educationalFacilities;

    //철도지하철 수
    @Column(name = "train/subway")
    private Double trainSubway;
}
