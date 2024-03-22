package com.sc.sangchu.controller;

import com.sc.sangchu.dto.consumer.CommIncomeDTO;
import com.sc.sangchu.postgresql.service.CommConsumerService;
import com.sc.sangchu.response.ErrorResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/consumer")
@CrossOrigin
@Tag(name = "상권 소비자 컨트롤러", description = "상권 소비자 관련 데이터 처리 컨트롤러")
public class CommConsumerController {
    private final CommConsumerService commConsumerService;

    @Autowired
    public CommConsumerController(CommConsumerService commConsumerService) {
        this.commConsumerService = commConsumerService;
    }

    @GetMapping("/income-consumption")
    @Operation(summary = "서울시 총 소득 및 특정 상권 소득 지출 조회",
            description = "서울시 총 월 평균 소득, 특정 상권의 월 평균 소득과 총 지출을 보여줍니다. (단위: 원)")
    public ResponseEntity<?> getIncome(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommIncomeDTO commIncomeDTO = commConsumerService.getIncome(commercialDistrictCode);
            if(commIncomeDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("Consumer Controller getIncome NullException"));
            }
            return ResponseEntity.ok(commIncomeDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("Consumer Controller getIncome failure"));
        }
    }
}
