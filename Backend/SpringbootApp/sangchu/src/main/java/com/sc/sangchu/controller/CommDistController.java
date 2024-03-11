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

    // 상권 데이터 조회
    @GetMapping("/{coId}")
    @Operation(summary = "상권 정보 조회", description = "상권 ID를 기반으로 상권 정보를 조회합니다.")
    public ResponseEntity<CommDistDTO> getCommDist(
            @PathVariable @Parameter(description = "상권 ID") int coId) {
        CommDistEntity commDistEntity = commDistService.getCommDistById(coId);
        CommDistDTO commDistDTO = commDistService.convertToDTO(commDistEntity);
        return ResponseEntity.ok(commDistDTO);
    }

    // 모든 상권 데이터 조회
    @GetMapping("/all")
    @Operation(summary = "모든 상권 정보 조회", description = "모든 상권 정보를 조회합니다.")
    public ResponseEntity<List<CommDistDTO>> getAllCommDist() {
        List<CommDistEntity> allCommDist = commDistService.getAllCommDistData();
        List<CommDistDTO> commDistDTOs = commDistService.convertToDTOs(allCommDist);
        return ResponseEntity.ok(commDistDTOs);
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
