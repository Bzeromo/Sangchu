package com.sc.sangchu.dto;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CommDistRankDTO {

    private Long cdCode;
    private String name;
    private valueScoreLong totalScore;
    private valueScoreDouble sales;
    private valueScoreLong footTraffic;
    private valueScoreLong residentialPopulation;
    private valueScoreLong businessDiversity;

    @Data
    @Builder
    public static class valueScoreLong{
        Long value;
        Double score;
    }
    @Data
    @Builder
    public static class valueScoreDouble{
        Double value;
        Double score;

    }
}
