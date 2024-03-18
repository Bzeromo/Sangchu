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
@Table(name = "comm_floating_population_tb")
public class CommFloatingPopulationEntity {

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

    //총 유동인구 수
    @Column(name = "total_foot_traffic")
    private Long totalFloatingPopulation;

    //10대 유동인구 수
    @Column(name = "age_10_foot_traffic")
    private Long age10FloatingPopulation;

    //20대 유동인구 수
    @Column(name = "age_20_foot_traffic")
    private Long age20FloatingPopulation;

    //30대 유동인구 수
    @Column(name = "age_30_foot_traffic")
    private Long age30FloatingPopulation;

    //40대 유동인구 수
    @Column(name = "age_40_foot_traffic")
    private Long age40FloatingPopulation;

    //50대 유동인구 수
    @Column(name = "age_50_foot_traffic")
    private Long age50FloatingPopulation;

    //60대 이상 유동인구 수
    @Column(name = "age_over_60_foot_traffic")
    private Long ageOver60FloatingPopulation;

    //00~06시 유동인구 수
    @Column(name = "time_00_to_06_foot_traffic")
    private Long time00To06FloatingPopulation;

    //06~11시 유동인구 수
    @Column(name = "time_06_to_11_foot_traffic")
    private Long time06To11FloatingPopulation;

    //11~14시 유동인구 수
    @Column(name = "time_11_to_14_foot_traffic")
    private Long time11To14FloatingPopulation;

    //14~17시 유동인구 수
    @Column(name = "time_14_to_17_foot_traffic")
    private Long time14To17FloatingPopulation;

    //17~21시 유동인구 수
    @Column(name = "time_17_to_21_foot_traffic")
    private Long time17To21FloatingPopulation;

    //21~24시 유동인구 수
    @Column(name = "time_21_to_24_foot_traffic")
    private Long time21To24FloatingPopulation;

    //월요일 유동인구 수
    @Column(name = "mon_foot_traffic")
    private Long monFloatingPopulation;

    //화요일 유동인구 수
    @Column(name = "tue_foot_traffic")
    private Long tueFloatingPopulation;

    //수요일 유동인구 수
    @Column(name = "wed_foot_traffic")
    private Long wedFloatingPopulation;

    //목요일 유동인구 수
    @Column(name = "thu_foot_traffic")
    private Long thuFloatingPopulation;

    //금요일 유동인구 수
    @Column(name = "fri_foot_traffic")
    private Long friFloatingPopulation;

    //토요일 유동인구 수
    @Column(name = "sat_foot_traffic")
    private Long satFloatingPopulation;

    //일요일 유동인구 수
    @Column(name = "sun_foot_traffic")
    private Long sunFloatingPopulation;

}
