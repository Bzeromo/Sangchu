package com.sc.sangchu.controller;

import com.sc.sangchu.dto.CommDistDTO;
import com.sc.sangchu.dto.CommSalesDto;
import com.sc.sangchu.postgresql.service.CommGraphService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/graph")
@CrossOrigin
@Tag(name = "상권 그래프 컨트롤러", description = "상권 그레프 관련 데이터 처리 컨트롤러")
public class CommGraphController {

    private final CommGraphService commGraphService;

    @Autowired
    public CommGraphController(CommGraphService commGraphService) {
        this.commGraphService = commGraphService;
    }

    @GetMapping("/sales")
    @Operation(summary = "특정 상권 매출 금액 조회", description = "월평균, 주중, 주말 매출 금액(22~23년) 조회")
    public ResponseEntity<CommSalesDto> getSales(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommSalesDto commSalesDto = commGraphService.getSalesData(commercialDistrictCode);
        return ResponseEntity.ok(commSalesDto);
    }
}
