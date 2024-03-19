package com.sc.sangchu.controller;

import com.sc.sangchu.dto.sales.CommQuarterlyGraphDTO;
import com.sc.sangchu.dto.sales.CommQuarterlyGraphJsonDTO;
import com.sc.sangchu.dto.sales.CommSalesDto;
import com.sc.sangchu.postgresql.service.CommSalesGraphService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
    @Operation(summary = "특정 상권 매출 금액 조회", description = "분기별 월평균(주중, 주말) 매출 그래프 (22~23년) 조회")
    public ResponseEntity<CommQuarterlyGraphJsonDTO> getQuarterlyGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommQuarterlyGraphJsonDTO commQuarterlyGraphDTOList = commSalesGraphService.getQuarterlyData(commercialDistrictCode);
        return ResponseEntity.ok(commQuarterlyGraphDTOList);
    }
}
