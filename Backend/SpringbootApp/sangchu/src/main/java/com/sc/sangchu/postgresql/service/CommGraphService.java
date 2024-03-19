package com.sc.sangchu.postgresql.service;

import com.sc.sangchu.dto.CommSalesDto;
import com.sc.sangchu.postgresql.entity.CommEstimatedSalesEntity;
import com.sc.sangchu.postgresql.repository.CommEstimatedSalesRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
public class CommGraphService {

    private final CommEstimatedSalesRepository commEstimatedSalesRepository;
    private final int[] stdYears = {2022, 2023};

    @Autowired
    public CommGraphService(CommEstimatedSalesRepository commEstimatedSalesRepository) {
        this.commEstimatedSalesRepository = commEstimatedSalesRepository;
    }

    //특정 상권 코드에 해당하는 월 매출, 주중/주말 매출 조회
    public CommSalesDto getSalesData (Long commCode) {
        //해당 분기 점포당 평균 월 매출 평균 = 원본데이터 / 3(1분기는 3개월) / 9(점포수)
        //해당 분기 점포당 주중 매출 평균 = 원본데이터 / 3(1분기는 3개월) / 4(한달은 4주) / 9(점포수)
        //해당 분기 점포당 월요일 매출 평균 = 원본데이터 / 3(1분기는 3개월) / 4(한달은 4주) / 9(점포수)
        //월 매출, 주중/주말 매출 계산
        List<CommEstimatedSalesEntity> salesList = commEstimatedSalesRepository.findByStandardYear(commCode, stdYears[1]);
        System.out.println(salesList.get(0));
        double monthlySales = 0.0;
        double weekdaySales = 0.0;
        double weekendSales = 0.0;
        for(CommEstimatedSalesEntity entity : salesList){
            monthlySales += entity.getMonthlySales();
            weekdaySales += entity.getWeekDaysSales();
            weekendSales += entity.getWeekendSales();
        }


        return CommSalesDto.builder()
                .MonthlySales(0.0)
                .WeekDaySales(0.0)
                .WeekendSales(0.0)
                .build();
    }
}
