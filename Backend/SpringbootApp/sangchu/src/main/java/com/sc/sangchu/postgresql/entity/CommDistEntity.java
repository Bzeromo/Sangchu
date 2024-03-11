package com.sc.sangchu.postgresql.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
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
@Table(name = "commdist")
public class CommDistEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer coId;

    private Integer areaCode;

    @Column(precision = 10, scale = 2) // 숫자 타입의 정밀도와 스케일 지정
    private Double coArea;

    private Integer coApart;
    private Integer coSales;
    private Integer coSalesScore;
    private Integer coFlPo;
    private Integer coFlPoScore;
    private Integer coRePo;
    private Integer coRePoScore;
    private Integer coWoPo;

    // 위치 좌표를 위한 필드
    private Integer coX;
    private Integer coY;

    // 기타 필드
    private Integer coIncome;
    private Integer coConsump;
    private String coChangeIndex;

    @Column(precision = 10, scale = 2)
    private Double coScore;

    @Column(precision = 10, scale = 2)
    private Double coCompScore;

    @Column(precision = 10, scale = 2)
    private Double coDiversityScore;
}
