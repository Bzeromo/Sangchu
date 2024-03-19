package com.sc.sangchu.controller;

import com.sc.sangchu.dto.CommAptDTO;
import com.sc.sangchu.dto.CommFacilitiesDTO;
import com.sc.sangchu.dto.CommIndicatorDTO;
import com.sc.sangchu.dto.CommStoreDTO;
import com.sc.sangchu.postgresql.service.CommInfraGraphService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/infra/graph")
@CrossOrigin
@Tag(name = "상권 환경 그래프 컨트롤러", description = "상권 환경 관련 그래프 데이터 처리 컨트롤러")
public class CommInfraGraphController {
    private final CommInfraGraphService commInfraGraphService;

    @Autowired
    public CommInfraGraphController(CommInfraGraphService commInfraGraphService) {
        this.commInfraGraphService = commInfraGraphService;
    }

    @GetMapping("/store/count")
    @Operation(summary = "특정 상권 점포 그래프 조회",
            description = "서비스업종코드와 업종 코드명, 점포 수와 프랜차이즈 점포 수를 JSON(Map<String, Object>) 형태로 넘깁니다.")
    public ResponseEntity<CommStoreDTO> getStoreGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommStoreDTO commStoreDTO = commInfraGraphService.getStoreDataAsJson(commercialDistrictCode);
        return ResponseEntity.ok(commStoreDTO);
    }
}

