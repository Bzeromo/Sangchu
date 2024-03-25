package com.sc.sangchu.controller;

import com.sc.sangchu.dto.CommDistDTO;
import com.sc.sangchu.dto.CommDistServiceScoreDTO;
import com.sc.sangchu.postgresql.service.CommDistRecommendService;
import com.sc.sangchu.response.ErrorResponse;
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
    public ResponseEntity<?> getAllCommDist() {
        try {
            List<CommDistDTO> commDistDTOs = commDistRecommendService.getAllCommDist();
            if(commDistDTOs == null || commDistDTOs.isEmpty()) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getAllCommDist NullException"));
            }
            return ResponseEntity.ok(commDistDTOs);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getAllCommDist failure"));
        }
    }

    // 모든 상권 데이터 중 coScore를 기준으로 상위 10개 데이터 조회
    @GetMapping("/top")
    @Operation(summary = "상위 상권 정보 조회", description = "coScore를 기준으로 서울시 상위 10개의 상권 정보를 조회합니다.")
    public ResponseEntity<?> getTopCommDistByCoScore() {
        try {
            List<CommDistDTO> topCommDistDTOs = commDistRecommendService.getTopCommDistByCoScore();
            if(topCommDistDTOs == null || topCommDistDTOs.isEmpty()) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getTopCommDistByCoScore NullException"));
            }
            return ResponseEntity.ok(topCommDistDTOs);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getTopCommDistByCoScore failure"));
        }
    }

    // 상권 데이터 조회
    @GetMapping("/commercial")
    @Operation(summary = "상권 정보 조회", description = "상권 ID를 기반으로 상권 정보를 조회합니다.")
    public ResponseEntity<?> getCommDistByCommercialDistrictCode(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode) {
        try {
            CommDistDTO commDistDTO = commDistRecommendService.getCommDist(commercialDistrictCode);
            if(commDistDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getCommDistByCommercialDistrictCode NullException"));
            }
            return ResponseEntity.ok(commDistDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getCommDistByCommercialDistrictCode failure"));
        }
    }

    // 자치구 기준 상권 데이터 조회
    @GetMapping("/gu")
    @Operation(summary = "자치구 별 상권 정보 조회", description = "자치구를 기반으로 상권 정보를 조회합니다.")
    public ResponseEntity<?> getCommDistByGuCode(
            @RequestParam(value = "guCode") Long guCode) {
        try {
            List<CommDistDTO> commDistDTOs = commDistRecommendService.getCommDistByGuCode(guCode);
            if(commDistDTOs == null || commDistDTOs.isEmpty()) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getCommDistByGuCode NullException"));
            }
            return ResponseEntity.ok(commDistDTOs);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getCommDistByGuCode failure"));
        }
    }

    @GetMapping("/gu/top")
    @Operation(summary = "자치구 별 상위 상권 정보 조회", description = "자치구를 기반으로 상권 정보 중 coScore가 높은 상위 10개를 조회합니다.")
    public ResponseEntity<?> getTopCommDistByGuCode(
            @RequestParam(value = "guCode") Long guCode) {
        try {
            List<CommDistDTO> topCommDistDTOs = commDistRecommendService.getTopCommDistByGuCodeAndCoScore(guCode);
            if(topCommDistDTOs == null || topCommDistDTOs.isEmpty()) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getTopCommDistByGuCode NullException"));
            }
            return ResponseEntity.ok(topCommDistDTOs);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getTopCommDistByGuCode failure"));
        }
    }

    // 업종 및 자치구 기준 상권 데이터 조회
    @GetMapping("/gu/service")
    @Operation(summary = "자치구 및 업종별 상권 정보 조회", description = "업종과 자치구를 기반으로 상권 정보를 조회합니다.")
    public ResponseEntity<?> getGuServiceCommDist(
            @RequestParam(value = "guCode") Long guCode, @RequestParam(value = "serviceCode") String serviceCode) {
        try {
            List<CommDistServiceScoreDTO> commDistServiceScoreDTOS = commDistRecommendService.getGuServiceCommDist(guCode, serviceCode);
            if(commDistServiceScoreDTOS == null || commDistServiceScoreDTOS.isEmpty()) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getGuServiceCommDist NullException"));
            }
            return ResponseEntity.ok(commDistServiceScoreDTOS);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getGuServiceCommDist failure"));
        }
    }

    // 해당 상권&업종 데이터 조회
    @GetMapping("/service")
    @Operation(summary = "업종 기반 해당 상권 정보 조회", description = "업종과 상권코드를 기반으로 해당 상권 정보를 조회합니다.")
    public ResponseEntity<?> getServiceCommDist(
            @RequestParam(value = "commCode") Long commCode, @RequestParam(value = "serviceCode") String serviceCode) {
        try {
            CommDistServiceScoreDTO commDistServiceScoreDTO = commDistRecommendService.getServiceCommDist(commCode, serviceCode);
            if(commDistServiceScoreDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getServiceCommDist NullException"));
            }
            return ResponseEntity.ok(commDistServiceScoreDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getServiceCommDist failure"));
        }
    }

    // 카테고리별 점수 및 지표 top 5 조회
    @GetMapping("/district-rank")
    @Operation(summary = "카테고리별 top 상권 점수 정보 조회", description = "업종과 자치구를 기반으로 해당 상권 점수 정보를 조회합니다.")
    public ResponseEntity<?> getDistrictRank(
            @RequestParam(value = "guCode") Long guCode, @RequestParam(value = "serviceCode") String serviceCode) {
        try {
            CommDistServiceScoreDTO commDistServiceScoreDTO = commDistRecommendService.getServiceCommDist(guCode, serviceCode);
            if(commDistServiceScoreDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getServiceCommDist NullException"));
            }
            return ResponseEntity.ok(commDistServiceScoreDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commDistController getServiceCommDist failure"));
        }
    }
}
