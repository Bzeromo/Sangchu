package com.sc.sangchu.controller;

import com.sc.sangchu.dto.consumer.CommFloatingPopulationDTO;
import com.sc.sangchu.dto.consumer.CommResidentPopulationDTO;
import com.sc.sangchu.dto.consumer.CommWorkingPopulationDTO;
import com.sc.sangchu.dto.infra.CommAptDTO;
import com.sc.sangchu.postgresql.service.CommConsumerGraphService;
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
    public ResponseEntity<CommFloatingPopulationDTO> getFloatingPopulationAgeGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommFloatingPopulationDTO commFloatingPopulationDTO = commConsumerGraphService.getFloatingPopulationAgeGraph(commercialDistrictCode);
        return ResponseEntity.ok(commFloatingPopulationDTO);
    }

    @GetMapping("/floating/time")
    @Operation(summary = "특정 상권 시간대별 유동인구 수 그래프 조회",
            description = "시간대 별 유동인구 수 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<CommFloatingPopulationDTO> getFloatingPopulationTimeGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommFloatingPopulationDTO commFloatingPopulationDTO = commConsumerGraphService.getFloatingPopulationTimeGraph(commercialDistrictCode);
        return ResponseEntity.ok(commFloatingPopulationDTO);
    }

    @GetMapping("/floating/day")
    @Operation(summary = "특정 상권 요일별 유동인구 수 그래프 조회",
            description = "요일 별 유동인구 수 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<CommFloatingPopulationDTO> getFloatingPopulationDayGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommFloatingPopulationDTO commFloatingPopulationDTO = commConsumerGraphService.getFloatingPopulationDayGraph(commercialDistrictCode);
        return ResponseEntity.ok(commFloatingPopulationDTO);
    }

    @GetMapping("/floating/quarterly-trends")
    @Operation(summary = "특정 상권 총 유동인구 분기별 추이 그래프 조회",
            description = "2022~2023 상권의 총 유동인구 분기별 추이 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<CommFloatingPopulationDTO> getFloatingPopulationQuarterlyTrendsGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommFloatingPopulationDTO commFloatingPopulationDTO = commConsumerGraphService.getFloatingPopulationQuarterlyTrendsGraph(commercialDistrictCode);
        return ResponseEntity.ok(commFloatingPopulationDTO);
    }

    @GetMapping("/resident/gender-age")
    @Operation(summary = "특정 상권의 성별, 연령대별 상주인구 그래프 조회",
            description = "성별, 연령대별 상주인구 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<CommResidentPopulationDTO>commResidentPopulationGenderAgeGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommResidentPopulationDTO commResidentPopulationDTO = commConsumerGraphService.getResidentPopulationGenderAgeGraph(commercialDistrictCode);
        return ResponseEntity.ok(commResidentPopulationDTO);
    }

    @GetMapping("/resident/quarterly-trends")
    @Operation(summary = "총 상주인구 분기별 추이 그래프 조회",
            description = "2022~2023 상권의 총 상주인구 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<CommResidentPopulationDTO>commResidentPopulationQuarterlyTrendsGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommResidentPopulationDTO commResidentPopulationDTO = commConsumerGraphService.getResidentPopulationQuarterlyTrendsGraph(commercialDistrictCode);
        return ResponseEntity.ok(commResidentPopulationDTO);
    }

    @GetMapping("/working/gender-age")
    @Operation(summary = "특정 상권의 성별, 연령대별 직장인구 그래프 조회",
            description = "성별, 연령대별 직장인구 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<CommWorkingPopulationDTO>commWorkingPopulationGenderAgeGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommWorkingPopulationDTO commWorkingPopulationDTO = commConsumerGraphService.getWorkingPopulationGenderAgeGraph(commercialDistrictCode);
        return ResponseEntity.ok(commWorkingPopulationDTO);
    }

    @GetMapping("/working/quarterly-trends")
    @Operation(summary = "총 직장인구 분기별 추이 그래프 조회",
            description = "2022~2023 상권의 총 직장인구 그래프를 JSON 형태로 넘깁니다.")
    public ResponseEntity<CommWorkingPopulationDTO>commWorkingPopulationQuarterlyTrendsGraph(
            @RequestParam(value = "commercialDistrictCode") Long commercialDistrictCode){
        CommWorkingPopulationDTO commWorkingPopulationDTO = commConsumerGraphService.getWorkingPopulationQuarterlyTrendsGraph(commercialDistrictCode);
        return ResponseEntity.ok(commWorkingPopulationDTO);
    }
}
