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
@Table(name = "commdist")
@IdClass(CommDistId.class)
public class CommDistEntity {

    @Id
    private Integer coId;
    @Id
    private String serviceCode;

    // 위치 좌표를 위한 필드
    private Integer coX;
    private Integer coY;

    // 기타 필드
    private String serviceName;
    private Double coArea;
    private String coName;
    private Integer majorCategoryCode;
    private String majorCategoryName;
    private String middleCategoryCode;
    private String middleCategoryName;
    private Integer guCode;
    private String guName;
    private Integer dongCode;
    private String dongName;

    // 총점, 상주인구점수, 매출점수, 유동인구점수, 점포밀도점수, 업종다양성점수
    private Double coScore;
    private Double coRePoScore;
    private Double coSalesScore;
    private Double coFlPoScore;
    private Double coCompScore;
    private Double coDiversityScore;
}
