package com.sc.sangchu.postgresql.service;

import java.util.ArrayList;
import java.util.List;

import com.sc.sangchu.dto.CommDistServiceScoreDTO;
import com.sc.sangchu.postgresql.entity.CommDistServiceScoreEntity;
import com.sc.sangchu.postgresql.repository.CommDistServiceScoreRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class CommDistServiceScoreService {
    private final CommDistServiceScoreRepository commDistServiceScoreRepository;

    @Autowired
    public CommDistServiceScoreService(CommDistServiceScoreRepository commDistServiceScoreRepository) {
        this.commDistServiceScoreRepository = commDistServiceScoreRepository;
    }

    // entity를 dto로 변환하는 메서드
    public CommDistServiceScoreDTO convertToDTO(CommDistServiceScoreEntity entity) {

        CommDistServiceScoreDTO dto = new CommDistServiceScoreDTO();

        dto.setId(entity.getId());
        dto.setCommercialDistrictCode(entity.getCommercialDistrictCode());
        dto.setCommercialDistrictName(entity.getCommercialDistrictName());
        dto.setServiceCode(entity.getServiceCode());
        dto.setServiceCodeName(entity.getServiceCodeName());
        dto.setServiceBigCategory(entity.getServiceBigCategory());
        dto.setServiceBigCategoryName(entity.getServiceBigCategoryName());
        dto.setServiceMcategory(entity.getServiceMcategory());
        dto.setServiceMcategoryName(entity.getServiceMcategoryName());
        dto.setSalesScore(entity.getSalesScore());
        dto.setStoreDensityScore(entity.getStoreDensityScore());

        return dto;
    }

    // entity들을 dto 리스트로 변환하는 메서드
    public List <CommDistServiceScoreDTO> convertToDTOs(List <CommDistServiceScoreEntity> commDistEntities) {

        List <CommDistServiceScoreDTO> dtoList = new ArrayList<>();

        if(!commDistEntities.isEmpty()) {
            for (CommDistServiceScoreEntity commDistServiceScoreEntity : commDistEntities) {
                CommDistServiceScoreDTO dto = convertToDTO(commDistServiceScoreEntity);
                dtoList.add(dto);
            }
        }

        return dtoList;
    }

    // 업종 코드와 상권 코드로 상권 데이터 조회
    public CommDistServiceScoreEntity getCommDistServiceScoreByCodes(Long commercialDistrictCode, Long serviceCode) {
        return commDistServiceScoreRepository.findByCommercialDistrictCodeAndServiceCode(commercialDistrictCode, serviceCode);
    }

    // 모든 업종 별 상권 점수 데이터 조회
    public List<CommDistServiceScoreEntity> getAllCommDistServiceScoreData() {
        return commDistServiceScoreRepository.findAll();
    }
}
