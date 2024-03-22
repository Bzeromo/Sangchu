package com.sc.sangchu.controller;

import com.sc.sangchu.dto.consumer.CommFloatingPopulationDTO;
import com.sc.sangchu.dto.consumer.CommResidentPopulationDTO;
import com.sc.sangchu.dto.consumer.CommWorkingPopulationDTO;
import com.sc.sangchu.postgresql.service.CommConsumerGraphService;
import com.sc.sangchu.response.ErrorResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/consumer/graph")
@CrossOrigin
@Tag(name = "상권 소비자 그래프 컨트롤러", description = "상권 소비자 관련 그래프 데이터 처리 컨트롤러")
public class CommConsumerGraphController {
    private CommConsumerGraphService commConsumerGraphService;

    @Autowired
    public CommConsumerGraphController(CommConsumerGraphService commConsumerGraphService) {
        this.commConsumerGraphService = commConsumerGraphService;
    }

    @GetMapping("/floating/age")
    @Operation(summary = "특정 상권 연령별 유동인구 수 그래프 조회",
            description = "연령 별 유동인구 수 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<?> getFloatingPopulationAgeGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommFloatingPopulationDTO commFloatingPopulationDTO = commConsumerGraphService.getFloatingPopulationAgeGraph(commercialDistrictCode);
            if(commFloatingPopulationDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController getFloatingPopulationAgeGraph NullException"));
            }
            return ResponseEntity.ok(commFloatingPopulationDTO);
        } catch(Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController getFloatingPopulationAgeGraph failure"));
        }
    }

    @GetMapping("/floating/time")
    @Operation(summary = "특정 상권 시간대별 유동인구 수 그래프 조회",
            description = "시간대 별 유동인구 수 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<?> getFloatingPopulationTimeGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommFloatingPopulationDTO commFloatingPopulationDTO = commConsumerGraphService.getFloatingPopulationTimeGraph(commercialDistrictCode);
            if(commFloatingPopulationDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController getFloatingPopulationTimeGraph NullException"));
            }
            return ResponseEntity.ok(commFloatingPopulationDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController getFloatingPopulationTimeGraph failure"));
        }

    }

    @GetMapping("/floating/day")
    @Operation(summary = "특정 상권 요일별 유동인구 수 그래프 조회",
            description = "요일 별 유동인구 수 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<?> getFloatingPopulationDayGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommFloatingPopulationDTO commFloatingPopulationDTO = commConsumerGraphService.getFloatingPopulationDayGraph(commercialDistrictCode);
            if(commFloatingPopulationDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController getFloatingPopulationDayGraph NullException"));
            }
            return ResponseEntity.ok(commFloatingPopulationDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController getFloatingPopulationDayGraph failure"));
        }
    }

    @GetMapping("/floating/quarterly-trends")
    @Operation(summary = "특정 상권 총 유동인구 분기별 추이 그래프 조회",
            description = "2022~2023 상권의 총 유동인구 분기별 추이 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<?> getFloatingPopulationQuarterlyTrendsGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommFloatingPopulationDTO commFloatingPopulationDTO = commConsumerGraphService.getFloatingPopulationQuarterlyTrendsGraph(commercialDistrictCode);
            if(commFloatingPopulationDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController getFloatingPopulationQuarterlyTrendsGraph NullException"));
            }
            return ResponseEntity.ok(commFloatingPopulationDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController getFloatingPopulationQuarterlyTrendsGraph failure"));
        }
    }

    @GetMapping("/resident/gender-age")
    @Operation(summary = "특정 상권의 성별, 연령대별 상주인구 그래프 조회",
            description = "성별, 연령대별 상주인구 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<?>commResidentPopulationGenderAgeGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommResidentPopulationDTO commResidentPopulationDTO = commConsumerGraphService.getResidentPopulationGenderAgeGraph(commercialDistrictCode);
            if(commResidentPopulationDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController commResidentPopulationGenderAgeGraph NullException"));
            }
            return ResponseEntity.ok(commResidentPopulationDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController commResidentPopulationGenderAgeGraph failure"));
        }
    }

    @GetMapping("/resident/quarterly-trends")
    @Operation(summary = "총 상주인구 분기별 추이 그래프 조회",
            description = "2022~2023 상권의 총 상주인구 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<?>commResidentPopulationQuarterlyTrendsGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommResidentPopulationDTO commResidentPopulationDTO = commConsumerGraphService.getResidentPopulationQuarterlyTrendsGraph(commercialDistrictCode);
            if(commResidentPopulationDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController commResidentPopulationQuarterlyTrendsGraph NullException"));
            }
            return ResponseEntity.ok(commResidentPopulationDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController commResidentPopulationQuarterlyTrendsGraph failure"));
        }
    }

    @GetMapping("/working/gender-age")
    @Operation(summary = "특정 상권의 성별, 연령대별 직장인구 그래프 조회",
            description = "성별, 연령대별 직장인구 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<?>commWorkingPopulationGenderAgeGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommWorkingPopulationDTO commWorkingPopulationDTO = commConsumerGraphService.getWorkingPopulationGenderAgeGraph(commercialDistrictCode);
            if(commWorkingPopulationDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController commWorkingPopulationGenderAgeGraph NullException"));
            }
            return ResponseEntity.ok(commWorkingPopulationDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController commWorkingPopulationGenderAgeGraph failure"));
        }
    }

    @GetMapping("/working/quarterly-trends")
    @Operation(summary = "총 직장인구 분기별 추이 그래프 조회",
            description = "2022~2023 상권의 총 직장인구 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<?>commWorkingPopulationQuarterlyTrendsGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        try {
            CommWorkingPopulationDTO commWorkingPopulationDTO = commConsumerGraphService.getWorkingPopulationQuarterlyTrendsGraph(commercialDistrictCode);
            if(commWorkingPopulationDTO == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController commWorkingPopulationQuarterlyTrendsGraph NullException"));
            }
            return ResponseEntity.ok(commWorkingPopulationDTO);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("commConsumerGraphController commWorkingPopulationQuarterlyTrendsGraph failure"));
        }
    }
}
