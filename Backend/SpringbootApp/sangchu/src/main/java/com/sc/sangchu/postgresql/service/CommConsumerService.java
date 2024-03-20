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
    private final Integer year = 2023;
    private final Integer quarter = 3;

    public CommConsumerService (CommIncomeRepository commIncomeRepository) {
        this.commIncomeRepository = commIncomeRepository;
    }

    // 서울시 총 월 평균 소득, 월 평균 소득, 총 지출 가져오기
    public CommIncomeDTO getIncome (Long commCode){
        try {
            List<CommIncomeEntity>commIncomeEntities = commIncomeRepository.findAllByYearCodeAndQuarterCode(year, quarter);

            // 월 평균 소득의 합을 계산
            double totalIncome = commIncomeEntities.stream()
                    .mapToDouble(CommIncomeEntity::getMonthlyAverageIncomeAmount)
                    .sum();

            // 서울시 총 월 평균 소득을 계산
            double averageIncome = totalIncome / commIncomeEntities.size();

            CommIncomeEntity commIncomeEntity =
                    commIncomeRepository.findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode, year, quarter);

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
