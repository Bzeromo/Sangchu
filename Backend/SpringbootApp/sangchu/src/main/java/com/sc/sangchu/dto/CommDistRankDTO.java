package com.sc.sangchu.dto;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CommDistRankDTO {

    private Long cdCode;
    private String name;
    private ValueScoreLong totalScore;
    private ValueScoreDouble sales;
    private ValueScoreLong footTraffic;
    private ValueScoreLong residentialPopulation;
    private ValueScoreLong businessDiversity;

    @Data
    @Builder
    public static class ValueScoreLong {
        Long value;
        Double score;
    }
    @Data
    @Builder
    public static class ValueScoreDouble {
        Double value;
        Double score;

    }
}
