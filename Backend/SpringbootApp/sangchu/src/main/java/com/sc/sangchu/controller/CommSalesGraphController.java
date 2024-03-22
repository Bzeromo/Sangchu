package com.sc.sangchu.controller;

import com.sc.sangchu.dto.sales.*;
import com.sc.sangchu.postgresql.service.CommSalesGraphService;
import com.sc.sangchu.response.ErrorResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/sales")
@CrossOrigin
@Tag(name = "상권 그래프 컨트롤러", description = "상권 그래프 관련 데이터 처리 컨트롤러")
public class CommSalesGraphController {

    private final CommSalesGraphService commSalesGraphService;

    @Autowired
    public CommSalesGraphController(CommSalesGraphService commSalesGraphService) {
        this.commSalesGraphService = commSalesGraphService;
    }

    @GetMapping("")
    @Operation(summary = "특정 상권 매출 금액 조회", description = "월평균, 주중, 주말 매출 금액(23년 3분기) 조회")
    public ResponseEntity<?> getSales(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommSalesDto commSalesDto = commSalesGraphService.getSalesData(commercialDistrictCode);
            if(commSalesDto == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("CommSalesGraphController getSales NullException"));
            }
            return ResponseEntity.ok(commSalesDto);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("CommSalesGraphController getSales failure"));
        }
    }

    @GetMapping("/graph/quarterly")
    @Operation(summary = "특정 상권 분기별 매출 금액 조회", description = "분기별 월평균(주중, 주말) 매출 그래프 (22~23년) 조회")
    public ResponseEntity<?> getQuarterlyGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommQuarterlyGraphJsonDTO commQuarterlyGraphDTOList = commSalesGraphService.getQuarterlyGraphData(commercialDistrictCode);
            if(commQuarterlyGraphDTOList == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("CommSalesGraphController getQuarterlyGraph NullException"));
            }
            return ResponseEntity.ok(commQuarterlyGraphDTOList);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("CommSalesGraphController getQuarterlyGraph failure"));
        }
    }

    @GetMapping("/graph/day")
    @Operation(summary = "특정 상권 요일별 매출 금액 조회", description = "요일별 매출 그래프 (23년) 조회")
    public ResponseEntity<?> getDayGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
         try {
            CommSalesGraphJsonDTO commQuarterlyGraphDTOList = commSalesGraphService.getDayGraphData(commercialDistrictCode);
            if(commQuarterlyGraphDTOList == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("CommSalesGraphController getDayGraph NullException"));
            }
            return ResponseEntity.ok(commQuarterlyGraphDTOList);
        } catch (Exception e) {
             return ResponseEntity.badRequest().body(new ErrorResponse("CommSalesGraphController getDayGraph failure"));
         }
    }
    @GetMapping("/graph/time")
    @Operation(summary = "특정 상권 시간대별 매출 금액 조회", description = "시간대별 매출 그래프 (23년) 조회")
    public ResponseEntity<?> getTimeGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommSalesGraphJsonDTO commTimeGraphJsonDTOList = commSalesGraphService.getTimeGraphData(commercialDistrictCode);
            if(commTimeGraphJsonDTOList == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("CommSalesGraphController getTimeGraph NullException"));
            }
            return ResponseEntity.ok(commTimeGraphJsonDTOList);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("CommSalesGraphController getTimeGraph failure"));
        }
    }
    @GetMapping("/graph/age")
    @Operation(summary = "특정 상권 시간대별 매출 금액 조회", description = "시간대별 매출 그래프 (23년) 조회")
    public ResponseEntity<?> getAgeGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommSalesGraphJsonDTO commAgeGraphJsonDTOList = commSalesGraphService.getAgeGraphData(commercialDistrictCode);
            if(commAgeGraphJsonDTOList == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("CommSalesGraphController getAgeGraph NullException"));
            }
            return ResponseEntity.ok(commAgeGraphJsonDTOList);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("CommSalesGraphController getAgeGraph failure"));
        }
    }

    @GetMapping("/graph/ratio-industry")
    @Operation(summary = "서비스 업종별 매출 비율 조회", description = "서비스 업종별 매출 비율 그래프 (23년) 조회")
    public ResponseEntity<?> getSalesRatioByServiceGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommSalesRatioByServiceJsonDTO commSalesRatioByServiceJsonDTOList = commSalesGraphService.getSalesRatioByService(commercialDistrictCode);
            if(commSalesRatioByServiceJsonDTOList == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("CommSalesGraphController getSalesRatioByServiceGraph NullException"));
            }
            return ResponseEntity.ok(commSalesRatioByServiceJsonDTOList);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("CommSalesGraphController getSalesRatioByServiceGraph failure"));
        }
    }
}
