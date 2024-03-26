package com.sc.sangchu.postgresql.service;

import com.sc.sangchu.dto.consumer.CommIncomeDTO;
import com.sc.sangchu.postgresql.entity.CommIncomeEntity;
import com.sc.sangchu.postgresql.repository.CommIncomeRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
public class CommConsumerService {
    private final CommIncomeRepository commIncomeRepository;
    private final static Integer YEAR = 2023;
    private final static Integer QUARTER = 3;

    public CommConsumerService (CommIncomeRepository commIncomeRepository) {
        this.commIncomeRepository = commIncomeRepository;
    }

    // 서울시 총 월 평균 소득, 월 평균 소득, 총 지출 가져오기
    public CommIncomeDTO getIncome (Long commCode){
        try {
            List<CommIncomeEntity>commIncomeEntities = commIncomeRepository.findAllByYearCodeAndQuarterCode(
                YEAR, QUARTER);

            // 월 평균 소득의 합을 계산
            double totalIncome = commIncomeEntities.stream()
                    .mapToDouble(CommIncomeEntity::getMonthlyAverageIncomeAmount)
                    .sum();

            // 서울시 총 월 평균 소득을 계산
            double averageIncome = totalIncome / commIncomeEntities.size();

            CommIncomeEntity commIncomeEntity =
                    commIncomeRepository.findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode,
                        YEAR, QUARTER);

            Double monthlyAverageIncome = commIncomeEntity.getMonthlyAverageIncomeAmount();
            Double expenditureTotal = commIncomeEntity.getExpenditureTotalAmount();

            return CommIncomeDTO.builder()
                    .seoulAllAverageIncome(averageIncome)
                    .monthlyAverageIncome(monthlyAverageIncome)
                    .expenditureTotal(expenditureTotal)
                    .build();
        } catch (Exception e) {
            log.error("getIncome error", e);
        }
        return null;
    }
}
