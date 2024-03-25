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
@Table(name = "comm_indicator_change_tb")
public class CommIndicatorChangeEntity {
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

    //상권 변화 지표 코드
    @Column(name = "commercial_district_change_indicator_code")
    private String commChangeIndicatorCode;

    //상권 변화 지표 코드 명
    @Column(name = "commercial_district_change_indicator_name")
    private String commChangeIndicatorName;

    //rdi
    @Column(name = "rdi")
    private Double rdi;

    //점포 밀집도
    @Column(name = "store_density")
    private Double storeDensity;
}
