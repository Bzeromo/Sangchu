package com.sc.sangchu.postgresql.service;

import com.sc.sangchu.dto.CommDistDTO;
import com.sc.sangchu.dto.CommDistRankDTO;
import com.sc.sangchu.dto.CommDistServiceScoreDTO;
import com.sc.sangchu.dto.CommDistSetRankDTO;
import com.sc.sangchu.dto.infra.CommStoreTotalCountDTO;
import com.sc.sangchu.postgresql.entity.CommDistEntity;
import com.sc.sangchu.postgresql.entity.CommEstimatedSalesEntity;
import com.sc.sangchu.postgresql.entity.CommFloatingPopulationEntity;
import com.sc.sangchu.postgresql.entity.CommResidentPopulationEntity;
import com.sc.sangchu.postgresql.repository.*;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.OptionalInt;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.LongStream;

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
    private final CommStoreRepository commStoreRepository;
    private final Integer year = 2023;
    private final Integer quarter = 3;
    private final Integer rankLimit = 10;

    @Autowired
    public CommDistRecommendService(CommDistRepository commDistRepository,
                                    CommEstimatedSalesRepository commEstimatedSalesRepository, CommFloatingPopulationRepository commFloatingPopulationRepository, CommResidentPopulationRepository commResidentPopulationRepository, CommStoreRepository commStoreRepository) {
        this.commDistRepository = commDistRepository;
        this.commEstimatedSalesRepository = commEstimatedSalesRepository;
        this.commFloatingPopulationRepository = commFloatingPopulationRepository;
        this.commResidentPopulationRepository = commResidentPopulationRepository;
        this.commStoreRepository = commStoreRepository;
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
        try{
            // 자치구에 해당하는 상권 리스트 -> 상권 정보 및 점수
            List<CommDistEntity>  commDistEntities = commDistRepository.findByGuCode(guCode);
            if(commDistEntities.isEmpty()) return null;

            List<CommDistDTO> commList = setCommDistDtoList(commDistEntities);

            return setCommDistRankDTOs(commList, serviceCode);
        }catch (Exception e){
            log.error("getDistrictRank error", e);
        }
        return null;
    }

    public List<CommDistDTO> setCommDistDtoList(List<CommDistEntity> list){
        List<CommDistDTO> commDistDTOS = new ArrayList<>();

        for(CommDistEntity entity : list) {
            CommDistDTO dto;

            dto = CommDistDTO.builder()
                    .commercialDistrictCode(entity.getCommercialDistrictCode())
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
    public List<CommDistRankDTO> setCommDistRankDTOs(List<CommDistDTO> commDistList, String serviceCode){


        return commDistList.stream()
                .map(dto -> {
                    Long cdCode = dto.getCommercialDistrictCode();
                    String name = dto.getCommercialDistrictName();

                    Long totalScoreRank = commDistRepository.findAllByCommercialDistrictCode()
                            .stream()
                            .filter(f -> f.getCommCode().equals(cdCode))
                            .mapToLong(CommDistSetRankDTO::getRank)
                            .findFirst()
                            .orElse(0L);;

                    // 현재 분기 매출
                    CommEstimatedSalesEntity estimatedSalesEntity = commEstimatedSalesRepository.findByYearCodeAndQuarterCodeAndCommercialDistrictCodeAndServiceCode(year, quarter, cdCode,serviceCode);

                    // 현재 분기 총 업종 점포 수
                    CommStoreTotalCountDTO commStoreTotalCountDTO = commStoreRepository.findStoreTotalCount(year, quarter, cdCode);

                    // 현재 분기 유동 인구 수
                    CommFloatingPopulationEntity commFloatingPopulationEntity = commFloatingPopulationRepository.findByCommercialDistrictCodeAndYearCodeAndQuarterCode(cdCode, year, quarter);

                    // 현재 분기 상주 인구 수
                    CommResidentPopulationEntity commResidentPopulationEntity = commResidentPopulationRepository.findByCommercialDistrictCodeAndYearCodeAndQuarterCode(cdCode, year, quarter);

                    return CommDistRankDTO.builder()
                            .cdCode(dto.getCommercialDistrictCode())
                            .name(name)
                            .totalScore(CommDistRankDTO.valueScoreLong.builder()
                                    .value(totalScoreRank)
                                    .score(dto.getCommercialDistrictScore())
                                    .build())
                            .sales(CommDistRankDTO.valueScoreDouble.builder()
                                    .value(estimatedSalesEntity != null ? estimatedSalesEntity.getMonthlySales() : 0D)
                                    .score(dto.getSalesScore())
                                    .build())
                            .businessDiversity(CommDistRankDTO.valueScoreLong.builder()
                                    .value(commStoreTotalCountDTO != null ? commStoreTotalCountDTO.getTotalStoreCount() : 0L)
                                    .score(dto.getRdiScore())
                                    .build())
                            .footTraffic(CommDistRankDTO.valueScoreLong.builder()
                                    .value(commFloatingPopulationEntity != null ? commFloatingPopulationEntity.getTotalFloatingPopulation() : 0L)
                                    .score(dto.getFloatingPopulationScore())
                                    .build())
                            .residentialPopulation(CommDistRankDTO.valueScoreLong.builder()
                                    .value(commResidentPopulationEntity != null ? commResidentPopulationEntity.getTotalResidentPopulation() : 0L)
                                    .score(dto.getResidentPopulationScore())
                                    .build())
                            .build();
                })
                .toList();
    }
}
