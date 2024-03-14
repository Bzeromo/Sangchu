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
//@IdClass(CommDistId.class)
public class CommDistEntity {

    @Id
    @Column(name= "commercial_district_code")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long coId;

    @Column(name= "commercial_district_name")
    private String coName;

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
}
