package com.sc.sangchu.controller;

import com.sc.sangchu.dto.infra.CommAptDTO;
import com.sc.sangchu.dto.infra.CommFacilitiesDTO;
import com.sc.sangchu.dto.infra.CommIndicatorDTO;
import com.sc.sangchu.postgresql.service.CommInfraService;
import com.sc.sangchu.response.ErrorResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/infra")
@CrossOrigin
@Tag(name = "상권 환경 컨트롤러", description = "상권 환경 관련 데이터 처리 컨트롤러")
public class CommInfraController {
    private final CommInfraService commInfraService;

    @Autowired
    public CommInfraController(CommInfraService commInfraService) {
        this.commInfraService = commInfraService;
    }

    @GetMapping("/indicator/rdi")
    @Operation(summary = "특정 상권 업종 다양성 지수 조회", description = "사분위화 하여 하, 중, 상, 최상으로 분류합니다.")
    public ResponseEntity<?> getRDI(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommIndicatorDTO commIndicatorDTO = commInfraService.getRDI(commercialDistrictCode);
            if(commIndicatorDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("CommInfraController getRDI NullException"));
            }
            return ResponseEntity.ok(commIndicatorDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("CommInfraController getRDI failure"));
        }
    }

    @GetMapping("/indicator")
    @Operation(summary = "특정 상권 변화 지표 조회", description = "상권 변화 지표를 정체, 상권 축소, 상권 확장, 다이나믹으로 분류합니다.")
    public ResponseEntity<?> getChangeIndicator(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommIndicatorDTO commIndicatorDTO = commInfraService.getChangeIndicatorName(commercialDistrictCode);
            if(commIndicatorDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("CommInfraController getChangeIndicator NullException"));
            }
            return ResponseEntity.ok(commIndicatorDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("CommInfraController getChangeIndicator failure"));
        }
    }

    @GetMapping("/apt")
    @Operation(summary = "특정 상권 아파트 지표 조회", description = "아파트 단지 수, 평균 면적, 평균 시가를 보여줍니다.")
    public ResponseEntity<?> getApt(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommAptDTO commAptDTO = commInfraService.getApt(commercialDistrictCode);
            if(commAptDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("CommInfraController getApt NullException"));
            }
            return ResponseEntity.ok(commAptDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("CommInfraController getApt failure"));
        }
    }

    @GetMapping("/facility")
    @Operation(summary = "특정 상권 집객시설 지표 조회", description = "총 집객시설 수, 버스 시설 수, 문화/관광 시설 수, 교육 시설 수, 기차/지하철 수를 보여줍니다.")
    public ResponseEntity<?> getFacilities(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommFacilitiesDTO commFacilitiesDTO = commInfraService.getFacilities(commercialDistrictCode);
            if(commFacilitiesDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("CommInfraController getFacilities NullException"));
            }
            return ResponseEntity.ok(commFacilitiesDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("CommInfraController getFacilities failure"));
        }
    }
}
