package com.sc.sangchu.postgresql.service;

import com.sc.sangchu.dto.CommDistDTO;
import com.sc.sangchu.dto.CommDistRankDTO;
import com.sc.sangchu.dto.CommDistServiceScoreDTO;
import com.sc.sangchu.postgresql.entity.CommDistEntity;
import com.sc.sangchu.postgresql.entity.CommEstimatedSalesEntity;
import com.sc.sangchu.postgresql.entity.CommFloatingPopulationEntity;
import com.sc.sangchu.postgresql.entity.CommResidentPopulationEntity;
import com.sc.sangchu.postgresql.repository.CommDistRepository;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import com.sc.sangchu.postgresql.repository.CommEstimatedSalesRepository;
import com.sc.sangchu.postgresql.repository.CommFloatingPopulationRepository;
import com.sc.sangchu.postgresql.repository.CommResidentPopulationRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class CommDistRecommendService {
    private final CommDistRepository commDistRepository;
    private final CommEstimatedSalesRepository commEstimatedSalesRepository;
    private final CommFloatingPopulationRepository commFloatingPopulationRepository;
    private final CommResidentPopulationRepository commResidentPopulationRepository;
    private final Integer year = 2023;
    private final Integer quarter = 3;
    private final Integer rankLimit = 10;

    @Autowired
    public CommDistRecommendService(CommDistRepository commDistRepository,
                                    CommEstimatedSalesRepository commEstimatedSalesRepository, CommFloatingPopulationRepository commFloatingPopulationRepository, CommResidentPopulationRepository commResidentPopulationRepository) {
        this.commDistRepository = commDistRepository;
        this.commEstimatedSalesRepository = commEstimatedSalesRepository;
        this.commFloatingPopulationRepository = commFloatingPopulationRepository;
        this.commResidentPopulationRepository = commResidentPopulationRepository;
    }

    // 상권 코드로 상권 데이터 조회
    public CommDistDTO getCommDist(Long commCode) {
        try {
            CommDistEntity commDistEntity = commDistRepository.findByCommercialDistrictCode(commCode);

            return CommDistDTO.builder()
                    .commercialDistrictName(commDistEntity.getCommercialDistrictName())
                    .latitude(commDistEntity.getLatitude())
                    .longitude(commDistEntity.getLongitude())
                    .guCode(commDistEntity.getGuCode())
                    .guName(commDistEntity.getGuName())
                    .dongCode(commDistEntity.getDongCode())
                    .dongName(commDistEntity.getDongName())
                    .areaSize(commDistEntity.getAreaSize())
                    .commercialDistrictScore(commDistEntity.getCommercialDistrictScore())
                    .salesScore(commDistEntity.getSalesScore())
                    .residentPopulationScore(commDistEntity.getResidentPopulationScore())
                    .floatingPopulationScore(commDistEntity.getFloatingPopulationScore())
                    .rdiScore(commDistEntity.getRdiScore())
                    .build();
        } catch (Exception e) {
            log.error("getCommDist error", e);
        }
        return null;
    }

    // 모든 상권 데이터 조회
    public List <CommDistDTO> getAllCommDist() {
        try {
            List <CommDistEntity> commDistEntities = commDistRepository.findAll();
            if(commDistEntities.isEmpty()) return null;

            return setCommDistDtoList(commDistEntities);
        } catch (Exception e) {
            log.error("getAllCommDist error", e);
        }
        return null;
    }

    // 특정 조건에 따른 상권 데이터 조회
    // 지역 코드에 따라 조회
    public List<CommDistDTO> getCommDistByGuCode(Long guCode) {
        try {
            List <CommDistEntity> commDistEntities = commDistRepository.findByGuCode(guCode);
            if(commDistEntities.isEmpty()) return null;

            return setCommDistDtoList(commDistEntities);
        } catch (Exception e) {
            log.error("getCommDistByGuCode error", e);
        }
        return null;
    }

    // 서울시 전체 상권을 조회 후 총점 기준으로 10개만 정렬
    public List<CommDistDTO> getTopCommDistByCoScore() {
        try {
            List<CommDistEntity> sortedEntities = commDistRepository.findAll()
                    .stream()
                    .sorted(Comparator.comparing(CommDistEntity::getCommercialDistrictScore).reversed())
                    .limit(rankLimit)
                    .toList();
            if(sortedEntities.isEmpty()) return null;

            return setCommDistDtoList(sortedEntities);
        } catch (Exception e) {
            log.error("getTopCommDistByCoScore error", e);
        }
        return null;
    }

    // 자치구 기준으로 조회된 상권에서 coScore가 높은 순으로 10개를 찾아 내림차순 정렬
    public List<CommDistDTO> getTopCommDistByGuCodeAndCoScore(Long guCode) {
        try {
            List<CommDistEntity> sortedEntities = commDistRepository.findByGuCode(guCode)
                    .stream()
                    .sorted(Comparator.comparing(CommDistEntity::getCommercialDistrictScore).reversed())
                    .limit(rankLimit)
                    .toList();
            if(sortedEntities.isEmpty()) return null;

            return setCommDistDtoList(sortedEntities);

        } catch (Exception e) {
            log.error("getTopCommDistByGuCodeAndCoScore error", e);
        }
        return null;
    }

    // 업종별 상권 데이터 조회
    public CommDistServiceScoreDTO getServiceCommDist(Long commCode, String serviceCode) {
        try {
            CommDistEntity commDistEntity = commDistRepository.findByCommercialDistrictCode(commCode);
            CommEstimatedSalesEntity commEstimatedSalesEntity =
                    commEstimatedSalesRepository.findByYearCodeAndQuarterCodeAndCommercialDistrictCodeAndServiceCode(year, quarter, commCode, serviceCode);

            return CommDistServiceScoreDTO.builder()
                    .commercialDistrictName(commDistEntity.getCommercialDistrictName())
                    .latitude(commDistEntity.getLatitude())
                    .longitude(commDistEntity.getLongitude())
                    .guCode(commDistEntity.getGuCode())
                    .guName(commDistEntity.getGuName())
                    .dongCode(commDistEntity.getDongCode())
                    .dongName(commDistEntity.getDongName())
                    .areaSize(commDistEntity.getAreaSize())
                    .commercialDistrictScore(commDistEntity.getCommercialDistrictScore())
                    .salesScore(commEstimatedSalesEntity.getSalesScore())
                    .residentPopulationScore(commDistEntity.getResidentPopulationScore())
                    .floatingPopulationScore(commDistEntity.getFloatingPopulationScore())
                    .rdiScore(commDistEntity.getRdiScore())
                    .serviceBigCategory(commEstimatedSalesEntity.getMajorCategoryCode())
                    .serviceCode(commEstimatedSalesEntity.getServiceCode())
                    .serviceCodeName(commEstimatedSalesEntity.getServiceName())
                    .serviceBigCategoryName(commEstimatedSalesEntity.getMajorCategoryName())
                    .serviceMcategory(commEstimatedSalesEntity.getMiddleCategoryCode())
                    .serviceMcategoryName(commEstimatedSalesEntity.getMiddleCategoryName())
                    .build();
        } catch (Exception e) {
            log.error("getServiceCommDist error", e);
        }
        return null;
    }

    // 자치구별 업종별 상권 데이터 조회
    public List <CommDistServiceScoreDTO> getGuServiceCommDist(Long guCode, String serviceCode) {
        try {
            List <CommDistEntity> commDistEntities = commDistRepository.findByGuCode(guCode);
            List <CommDistServiceScoreDTO> commDistServiceScoreDTOS = new ArrayList<>();

            for(CommDistEntity entity : commDistEntities) {
                Long commCode = entity.getCommercialDistrictCode();

                CommEstimatedSalesEntity commEstimatedSalesEntity =
                        commEstimatedSalesRepository.findByYearCodeAndQuarterCodeAndCommercialDistrictCodeAndServiceCode(
                                year, quarter, commCode, serviceCode);

                if(commEstimatedSalesEntity == null) {
                    continue;
                }

                CommDistServiceScoreDTO dto = CommDistServiceScoreDTO.builder()
                        .commercialDistrictName(entity.getCommercialDistrictName())
                        .latitude(entity.getLatitude())
                        .longitude(entity.getLongitude())
                        .guCode(entity.getGuCode())
                        .guName(entity.getGuName())
                        .dongCode(entity.getDongCode())
                        .dongName(entity.getDongName())
                        .areaSize(entity.getAreaSize())
                        .commercialDistrictScore(entity.getCommercialDistrictScore())
                        .salesScore(commEstimatedSalesEntity.getSalesScore())
                        .residentPopulationScore(entity.getResidentPopulationScore())
                        .floatingPopulationScore(entity.getFloatingPopulationScore())
                        .rdiScore(entity.getRdiScore())
                        .serviceBigCategory(commEstimatedSalesEntity.getMajorCategoryCode())
                        .serviceCode(commEstimatedSalesEntity.getServiceCode())
                        .serviceCodeName(commEstimatedSalesEntity.getServiceName())
                        .serviceBigCategoryName(commEstimatedSalesEntity.getMajorCategoryName())
                        .serviceMcategory(commEstimatedSalesEntity.getMiddleCategoryCode())
                        .serviceMcategoryName(commEstimatedSalesEntity.getMiddleCategoryName())
                        .build();

                commDistServiceScoreDTOS.add(dto);
            }

            return commDistServiceScoreDTOS;
        } catch (Exception e) {
            log.error("getGuServiceCommDist error", e);
        }
        return null;
    }

    public List<CommDistRankDTO> getDistrictRank(Long guCode, String serviceCode){
        // 자치구에 해당하는 상권 리스트 -> 상권 정보 및 점수
        List<CommDistEntity>  commDistEntities = commDistRepository.findByGuCode(guCode);
        if(commDistEntities.isEmpty()) return null;

        List<CommDistDTO> commList = setCommDistDtoList(commDistEntities);
        List<Long> commCodeList = setCommCodeList(commDistEntities);
        // 위의 상권 리스트를 바탕으로 매출액, 유동인구수, 상주인구수, 업종다양성 수
        List<CommDistRankDTO> commDistRankDTOList = setCommDistRankDTOs(commList, commCodeList, serviceCode);


        return null;
    }

    public List<CommDistDTO> setCommDistDtoList(List<CommDistEntity> list){
        List<CommDistDTO> commDistDTOS = new ArrayList<>();

        for(CommDistEntity entity : list) {
            CommDistDTO dto;

            dto = CommDistDTO.builder()
                    .commercialDistrictName(entity.getCommercialDistrictName())
                    .latitude(entity.getLatitude())
                    .longitude(entity.getLongitude())
                    .guCode(entity.getGuCode())
                    .guName(entity.getGuName())
                    .dongCode(entity.getDongCode())
                    .dongName(entity.getDongName())
                    .areaSize(entity.getAreaSize())
                    .commercialDistrictScore(entity.getCommercialDistrictScore())
                    .salesScore(entity.getSalesScore())
                    .residentPopulationScore(entity.getResidentPopulationScore())
                    .floatingPopulationScore(entity.getFloatingPopulationScore())
                    .rdiScore(entity.getRdiScore())
                    .build();

            commDistDTOS.add(dto);
        }
        return commDistDTOS;
    }
    public List<Long> setCommCodeList(List<CommDistEntity> list){
        List<Long> commCodeList = new ArrayList<>();

        for(CommDistEntity entity : list){
            commCodeList.add(entity.getCommercialDistrictCode());
        }

        return commCodeList;
    }
    public List<CommDistRankDTO> setCommDistRankDTOs(List<CommDistDTO> commDistList, List<Long> commCodeList, String serviceCode){

        List<CommEstimatedSalesEntity> salesList = commEstimatedSalesRepository.findByYearCodeAndQuarterCodeAndCommercialDistrictCodeAndServiceCode(year, quarter, commCodeList, serviceCode);
        List<CommFloatingPopulationEntity> floatingList = commFloatingPopulationRepository.findByYearAndQuarterCodeAndCommercialDistrictCode(year, quarter, commCodeList);
        List<CommResidentPopulationEntity> residentList = commResidentPopulationRepository.findByYearAndQuarterCodeAndCommercialDistrictCode(year, quarter, commCodeList);

        List<CommDistRankDTO> list = new ArrayList<>();
        for(CommDistDTO dto : commDistList){
//            salesList.contains();
        }


        return null;
    }
}
