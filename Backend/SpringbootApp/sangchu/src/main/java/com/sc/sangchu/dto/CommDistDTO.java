package com.sc.sangchu.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CommDistDTO {
    private Integer quarterId;
    private Integer coId;
    private Integer bigCateId;
    private Integer midCateId;
    private Integer areaCode;
    private Double coArea;
    private Integer coX;
    private Integer coY;
    private Double coScore;
    private Integer coApart;
    private Integer coIncome;
    private Integer coConsump;
    private String coChangeIndex;
    private Integer coSales;
    private Integer coSalesScore;
    private Integer coFlPo;
    private Integer coFlPoScore;
    private Integer coRePo;
    private Integer coRePoScore;
    private Integer coWoPo;
    private Double coCompScore;
    private Double coDiversityScore;
}
