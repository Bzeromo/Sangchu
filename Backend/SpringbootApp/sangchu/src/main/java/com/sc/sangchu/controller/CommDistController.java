package com.sc.sangchu.controller;

import com.sc.sangchu.dto.CommDistDTO;
import com.sc.sangchu.dto.CommDistServiceScoreDTO;
import com.sc.sangchu.postgresql.service.CommDistRecommendService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/commdist")
@CrossOrigin
@Tag(name = "상권 컨트롤러", description = "상권 조회 및 상권(업종별) 추천 관련 데이터 처리 컨트롤러")
public class CommDistController {
    private final CommDistRecommendService commDistRecommendService;

    @Autowired
    public CommDistController(CommDistRecommendService commDistRecommendService) {
        this.commDistRecommendService = commDistRecommendService;
    }

    // 모든 상권 데이터 조회
    @GetMapping("/all")
    @Operation(summary = "모든 상권 정보 조회", description = "모든 상권 정보를 조회합니다.")
    public ResponseEntity<List<CommDistDTO>> getAllCommDist() {
        List<CommDistDTO> commDistDTOs = commDistRecommendService.getAllCommDist();
        return ResponseEntity.ok(commDistDTOs);
    }

    // 모든 상권 데이터 중 coScore를 기준으로 상위 10개 데이터 조회
    @GetMapping("/top")
    @Operation(summary = "상위 상권 정보 조회", description = "coScore를 기준으로 서울시 상위 10개의 상권 정보를 조회합니다.")
    public ResponseEntity<List<CommDistDTO>> getTopCommDistByCoScore() {
        List<CommDistDTO> topCommDistDTOs = commDistRecommendService.getTopCommDistByCoScore();
        return ResponseEntity.ok(topCommDistDTOs);
    }

    // 상권 데이터 조회
    @GetMapping("/commercial")
    @Operation(summary = "상권 정보 조회", description = "상권 ID를 기반으로 상권 정보를 조회합니다.")
    public ResponseEntity<CommDistDTO> getCommDistByCommercialDistrictCode(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode) {
        CommDistDTO commDistDTO = commDistRecommendService.getCommDist(commercialDistrictCode);
        return ResponseEntity.ok(commDistDTO);
    }

    // 자치구 기준 상권 데이터 조회
    @GetMapping("/gu")
    @Operation(summary = "자치구 별 상권 정보 조회", description = "자치구를 기반으로 상권 정보를 조회합니다.")
    public ResponseEntity<List<CommDistDTO>> getCommDistByGuCode(
            @RequestParam(value = "guCode") Long guCode) {
        List <CommDistDTO> commDistDTO = commDistRecommendService.getCommDistByGuCode(guCode);
        return ResponseEntity.ok(commDistDTO); 
    }

    @GetMapping("/gu/top")
    @Operation(summary = "자치구 별 상위 상권 정보 조회", description = "자치구를 기반으로 상권 정보 중 coScore가 높은 상위 10개를 조회합니다.")
    public ResponseEntity<List<CommDistDTO>> getTopCommDistByGuCode(
            @RequestParam(value = "guCode") Long guCode) {
        List<CommDistDTO> topCommDistDTOs = commDistRecommendService.getTopCommDistByGuCodeAndCoScore(guCode);
        return ResponseEntity.ok(topCommDistDTOs);
    }

    // 업종 및 자치구 기준 상권 데이터 조회
    @GetMapping("/gu/service")
    @Operation(summary = "자치구 및 업종별 상권 정보 조회", description = "업종과 자치구를 기반으로 상권 정보를 조회합니다.")
    public ResponseEntity<List<CommDistServiceScoreDTO>> getGuServiceCommDist(
            @RequestParam(value = "guCode") Long guCode, @RequestParam(value = "serviceCode") String serviceCode) {
        List <CommDistServiceScoreDTO> commDistServiceScoreDTOS = commDistRecommendService.getGuServiceCommDist(guCode, serviceCode);
        return ResponseEntity.ok(commDistServiceScoreDTOS);
    }

    // 해당 상권&업종 데이터 조회
    @GetMapping("/service")
    @Operation(summary = "업종 기반 해당 상권 정보 조회", description = "업종과 상권코드를 기반으로 해당 상권 정보를 조회합니다.")
    public ResponseEntity<CommDistServiceScoreDTO> getServiceCommDist(
            @RequestParam(value = "commCode") Long commCode, @RequestParam(value = "serviceCode") String serviceCode) {
        CommDistServiceScoreDTO commDistServiceScoreDTO = commDistRecommendService.getServiceCommDist(commCode, serviceCode);
        return ResponseEntity.ok(commDistServiceScoreDTO);
    }
}
