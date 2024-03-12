package com.sc.sangchu.controller;

import com.sc.sangchu.dto.CommDistDTO;
import com.sc.sangchu.postgresql.entity.CommDistEntity;
import com.sc.sangchu.postgresql.service.CommDistService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/commdist")
@CrossOrigin
@Tag(name = "상권 컨트롤러", description = "상권 관련 데이터 처리 컨트롤러")
public class CommDistController {

    private final CommDistService commDistService;

    @Autowired
    public CommDistController(CommDistService commDistService) {
        this.commDistService = commDistService;
    }

    // 모든 상권 데이터 조회
    @GetMapping("/all")
    @Operation(summary = "모든 상권 정보 조회", description = "모든 상권 정보를 조회합니다.")
    public ResponseEntity<List<CommDistDTO>> getAllCommDist() {
        List<CommDistEntity> allCommDist = commDistService.getAllCommDistData();
        List<CommDistDTO> commDistDTOs = commDistService.convertToDTOs(allCommDist);
        return ResponseEntity.ok(commDistDTOs);
    }

    // 모든 상권 데이터 중 coScore를 기준으로 상위 10개 데이터 조회
    @GetMapping("/top")
    @Operation(summary = "상위 상권 정보 조회", description = "coScore를 기준으로 상위 10개의 상권 정보를 조회합니다.")
    public ResponseEntity<List<CommDistDTO>> getTopCommDistByCoScore() {
        List<CommDistDTO> topCommDistDTOs = commDistService.getTopCommDistByCoScore(10);
        return ResponseEntity.ok(topCommDistDTOs);
    }

    // 상권 데이터 조회
    @GetMapping("/{coId}")
    @Operation(summary = "상권 정보 조회", description = "상권 ID를 기반으로 상권 정보를 조회합니다.")
    public ResponseEntity<CommDistDTO> getCommDistByCoId(
            @PathVariable @Parameter(description = "상권 ID") int coId) {
        CommDistEntity commDistEntity = commDistService.getCommDistById(coId);
        CommDistDTO commDistDTO = commDistService.convertToDTO(commDistEntity);
        return ResponseEntity.ok(commDistDTO);
    }

    // 업종 기준 상권 데이터 조회
    @GetMapping("/{serviceCode}")
    @Operation(summary = "업종별 상권 정보 조회", description = "업종 ID를 기반으로 상권 정보를 조회합니다.")
    public ResponseEntity<List<CommDistDTO>> getCommDistByCategoryId(
            @PathVariable @Parameter(description = "업종 ID") String serviceCode) {
        List <CommDistEntity> commDistEntity = commDistService.getCommDistByServiceCode(serviceCode);
        List <CommDistDTO> commDistDTO = commDistService.convertToDTOs(commDistEntity);
        return ResponseEntity.ok(commDistDTO);
    }

    // 자치구 기준 상권 데이터 조회
    @GetMapping("/{guCode}")
    @Operation(summary = "자치구 별 상권 정보 조회", description = "자치구를 기반으로 상권 정보를 조회합니다.")
    public ResponseEntity<List<CommDistDTO>> getCommDistByGuCode(
            @PathVariable @Parameter(description = "자치구 코드") int guCode) {
        List <CommDistEntity> commDistEntity = commDistService.getCommDistByGuCode(guCode);
        List <CommDistDTO> commDistDTO = commDistService.convertToDTOs(commDistEntity);
        return ResponseEntity.ok(commDistDTO);
    }

    // 자치구 및 업종 기준 상권 데이터 조회
    @GetMapping("/{serviceCode}/{guCode}")
    @Operation(summary = "자치구 및 업종별 상권 정보 조회", description = "업종 ID를 기반으로 상권 정보를 조회합니다.")
    public ResponseEntity<List<CommDistDTO>> getCommDistByServiceCodeAndGuCode(
            @PathVariable @Parameter(description = "업종 ID") String serviceCode, @PathVariable @Parameter(description = "자치구 코드") int guCode) {
        List <CommDistEntity> commDistEntity = commDistService.getCommDistByServiceCodeAndGuCode(serviceCode, guCode);
        List <CommDistDTO> commDistDTO = commDistService.convertToDTOs(commDistEntity);
        return ResponseEntity.ok(commDistDTO);
    }

    @GetMapping("/{guCode}/top")
    @Operation(summary = "자치구 별 상위 상권 정보 조회", description = "자치구를 기반으로 상권 정보 중 coScore가 높은 상위 10개를 조회합니다.")
    public ResponseEntity<List<CommDistDTO>> getTopCommDistByGuCode(
            @PathVariable @Parameter(description = "자치구 코드") int guCode) {
        List<CommDistDTO> topCommDistDTOs = commDistService.getTopCommDistByGuCodeAndCoScore(guCode, 10);
        return ResponseEntity.ok(topCommDistDTOs);
    }


//    // 상권 데이터 생성
//    @PostMapping
//    @Operation(summary = "새 상권 데이터 생성", description = "새로운 상권 데이터를 생성합니다.")
//    public ResponseEntity<CommDistDTO> createCommDist(@RequestBody CommDistDTO commDistDTO) {
//        CommDistEntity commDistEntity = commDistService.createCommDist(commDistDTO);
//        // Entity to DTO conversion logic should be added
//        CommDistDTO createdCommDistDTO = ... // convert entity to DTO
//        return ResponseEntity.ok(createdCommDistDTO);
//    }

//    // 상권 데이터 업데이트
//    @PutMapping("/{coId}")
//    @Operation(summary = "상권 정보 업데이트", description = "주어진 ID의 상권 정보를 업데이트합니다.")
//    public ResponseEntity<CommDistDTO> updateCommDist(
//            @PathVariable int coId,
//            @RequestBody CommDistDTO commDistDTO) {
//        CommDistEntity updatedEntity = commDistService.updateCommDist(coId, commDistDTO);
//        // Entity to DTO conversion logic should be added
//        CommDistDTO updatedCommDistDTO = ... // convert entity to DTO
//        return ResponseEntity.ok(updatedCommDistDTO);
//    }

    // 추가적인 API 엔드포인트 및 로직 구현이 필요함
    // ...
}
