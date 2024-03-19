package com.sc.sangchu.postgresql.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.sc.sangchu.dto.sales.CommQuarterlyGraphDTO;
import com.sc.sangchu.dto.sales.CommQuarterlyGraphJsonDTO;
import com.sc.sangchu.dto.sales.CommSalesDto;
import com.sc.sangchu.postgresql.entity.CommEstimatedSalesEntity;
import com.sc.sangchu.postgresql.repository.CommEstimatedSalesRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@Slf4j
public class CommSalesGraphService {

    private final CommEstimatedSalesRepository commEstimatedSalesRepository;
    private final ObjectMapper objectMapper;
    private final LocalDate localDate = LocalDate.now();

    @Autowired
    public CommSalesGraphService(CommEstimatedSalesRepository commEstimatedSalesRepository, ObjectMapper objectMapper) {
        this.commEstimatedSalesRepository = commEstimatedSalesRepository;
        this.objectMapper = objectMapper;
    }

    //특정 상권 코드에 해당하는 월 매출, 주중/주말 매출 조회
    public CommSalesDto getSalesData(Long commCode) {
        //매출 계산 로직 좀 더 고민해 봐야함.
        //월 매출, 주중/주말 매출 계산
        List<CommEstimatedSalesEntity> salesList = commEstimatedSalesRepository.findByStandardYear(commCode,
                localDate.getYear() - 1, "외식업");

        return calcSalesAvg(salesList);
    }

    public CommQuarterlyGraphJsonDTO getQuarterlyData(Long commCode) {
        //특정 상권 코드의 22~23년도 주중/주말 매출 조회
        List<CommQuarterlyGraphDTO> list = commEstimatedSalesRepository.findByQuarterlyData(commCode,
                "외식업", new int[]{localDate.getYear() - 2, localDate.getYear() - 1});

        ObjectNode chartData = objectMapper.createObjectNode();
        chartData.put("chartType", "stackbar");

        ObjectNode data = objectMapper.createObjectNode();
        ArrayNode categories = objectMapper.createArrayNode();
        ArrayNode series = objectMapper.createArrayNode();

        for(CommQuarterlyGraphDTO dto : list){
            String yearQuarter = dto.getYear().toString() + "." + dto.getQuarter().toString();
            categories.add(yearQuarter);
            ObjectNode seriesData = objectMapper.createObjectNode();
            seriesData.put("YearQuarter", yearQuarter);
            seriesData.put("WeekDaySales", String.format("%.0f", dto.getWeekDaySales()));
            seriesData.put("WeekendSales", String.format("%.0f", dto.getWeekendSales()));
            series.add(seriesData);
        }

        data.set("categories", categories);
        data.set("series", series);
        chartData.set("data", data);

        return CommQuarterlyGraphJsonDTO.builder()
                .quarterlyGraph(chartData)
                .build();
    }

    public CommSalesDto calcSalesAvg(List<CommEstimatedSalesEntity> salesList){
        if (salesList == null) {
            return null;
        }
        double monthlySales = 0.0;
        double weekdaySales = 0.0;
        double weekendSales = 0.0;

        for (CommEstimatedSalesEntity entity : salesList) {
            monthlySales += entity.getMonthlySales();
            weekdaySales += entity.getWeekDaysSales();
            weekendSales += entity.getWeekendSales();
        }

        double monthlySalesAvg = monthlySales / (salesList.size());
        double weekDaySalesAvg = weekdaySales / (salesList.size());
        double weekendSalesAvg = weekendSales / (salesList.size());

        return CommSalesDto.builder()
                .MonthlySales(Math.round(monthlySalesAvg))
                .WeekDaySales(Math.round(weekDaySalesAvg))
                .WeekendSales(Math.round(weekendSalesAvg))
                .build();
    }
}

