package com.sc.sangchu.controller;

import com.sc.sangchu.dto.sales.*;
import com.sc.sangchu.postgresql.service.CommSalesGraphService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/sales")
@CrossOrigin
@Tag(name = "상권 그래프 컨트롤러", description = "상권 그레프 관련 데이터 처리 컨트롤러")
public class CommSalesGraphController {

    private final CommSalesGraphService commSalesGraphService;

    @Autowired
    public CommSalesGraphController(CommSalesGraphService commSalesGraphService) {
        this.commSalesGraphService = commSalesGraphService;
    }

    @GetMapping("")
    @Operation(summary = "특정 상권 매출 금액 조회", description = "월평균, 주중, 주말 매출 금액(23년 3분기) 조회")
    public ResponseEntity<CommSalesDto> getSales(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommSalesDto commSalesDto = commSalesGraphService.getSalesData(commercialDistrictCode);
        return ResponseEntity.ok(commSalesDto);
    }

    @GetMapping("/graph/quarterly")
    @Operation(summary = "특정 상권 분기별 매출 금액 조회", description = "분기별 월평균(주중, 주말) 매출 그래프 (22~23년) 조회")
    public ResponseEntity<CommQuarterlyGraphJsonDTO> getQuarterlyGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommQuarterlyGraphJsonDTO commQuarterlyGraphDTOList = commSalesGraphService.getQuarterlyGraphData(commercialDistrictCode);
        return ResponseEntity.ok(commQuarterlyGraphDTOList);
    }

    @GetMapping("/graph/day")
    @Operation(summary = "특정 상권 요일별 매출 금액 조회", description = "요일별 매출 그래프 (23년) 조회")
    public ResponseEntity<CommSalesGraphJsonDTO> getDayGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommSalesGraphJsonDTO commQuarterlyGraphDTOList = commSalesGraphService.getDayGraphData(commercialDistrictCode);
        return ResponseEntity.ok(commQuarterlyGraphDTOList);
    }
    @GetMapping("/graph/time")
    @Operation(summary = "특정 상권 시간대별 매출 금액 조회", description = "시간대별 매출 그래프 (23년) 조회")
    public ResponseEntity<CommSalesGraphJsonDTO> getTimeGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommSalesGraphJsonDTO commTimeGraphJsonDTOList = commSalesGraphService.getTimeGraphData(commercialDistrictCode);
        return ResponseEntity.ok(commTimeGraphJsonDTOList);
    }
    @GetMapping("/graph/age")
    @Operation(summary = "특정 상권 시간대별 매출 금액 조회", description = "시간대별 매출 그래프 (23년) 조회")
    public ResponseEntity<CommSalesGraphJsonDTO> getAgeGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommSalesGraphJsonDTO commAgeGraphJsonDTOList = commSalesGraphService.getAgeGraphData(commercialDistrictCode);
        return ResponseEntity.ok(commAgeGraphJsonDTOList);
    }

    @GetMapping("/graph/ratio-industry")
    @Operation(summary = "서비스 업종별 매출 비율 조회", description = "서비스 업종별 매출 비율 그래프 (23년) 조회")
    public ResponseEntity<CommSalesRatioByServiceJsonDTO> getSalesRatioByServiceGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommSalesRatioByServiceJsonDTO commSalesRatioByServiceJsonDTOList =  commSalesGraphService.getSalesRatioByService(commercialDistrictCode);
        return ResponseEntity.ok(commSalesRatioByServiceJsonDTOList);
    }
}
