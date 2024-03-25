package com.sc.sangchu.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CommDistRankDTO {

    private Long cdCode;
    private String name;
    private valueScoreInteger totalScore;
    private valueScoreDouble sales;
    private valueScoreInteger footTraffic;
    private valueScoreInteger residentialPopulation;
    private valueScoreDouble businessDiversity;

    private static class valueScoreInteger{
        Integer value;
        Integer score;
    }
    private static class valueScoreDouble{
        Double value;
        Integer score;
    }
}
