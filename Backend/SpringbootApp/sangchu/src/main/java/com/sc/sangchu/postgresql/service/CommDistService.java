package com.sc.sangchu.postgresql.service;

import com.sc.sangchu.dto.CommDistDTO;
import com.sc.sangchu.postgresql.entity.CommDistEntity;
import com.sc.sangchu.postgresql.repository.CommDistRepository;


import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class CommDistService {
    private final CommDistRepository commDistRepository;

    @Autowired
    public CommDistService(CommDistRepository commDistRepository) {
        this.commDistRepository = commDistRepository;
    }

    // entity를 dto로 변환하는 메서드
    public CommDistDTO convertToDTO(CommDistEntity entity) {

        CommDistDTO dto = new CommDistDTO();

        dto.setCommercialDistrictScore(entity.getCommercialDistrictScore());
        dto.setCommercialDistrictName(entity.getCommercialDistrictName());
        dto.setLatitude(entity.getLatitude());
        dto.setLongitude(entity.getLongitude());
        dto.setGuCode(entity.getGuCode());
        dto.setGuName(entity.getGuName());
        dto.setDongCode(entity.getDongCode());
        dto.setDongName(entity.getDongName());
        dto.setAreaSize(entity.getAreaSize());
        dto.setCommercialDistrictScore(entity.getCommercialDistrictScore());
        dto.setSalesScore(entity.getSalesScore());
        dto.setResidentPopulationScore(entity.getResidentPopulationScore());
        dto.setFloatingPopulationScore(entity.getFloatingPopulationScore());
        dto.setStoreDensityScore(entity.getStoreDensityScore());
        dto.setRdiScore(entity.getRdiScore());

        return dto;
    }

    // entity들을 dto 리스트로 변환하는 메서드
    public List <CommDistDTO> convertToDTOs(List <CommDistEntity> commDistEntities) {

        List <CommDistDTO> dtoList = new ArrayList<>();

        if(!commDistEntities.isEmpty()) {
            for (CommDistEntity commDistEntity : commDistEntities) {
                CommDistDTO dto = convertToDTO(commDistEntity);
                dtoList.add(dto);
            }
        }

        return dtoList;
    }

    // 상권 코드로 상권 데이터 조회
    public CommDistEntity getCommDistById(Long commercialDistrictCode) {
        return commDistRepository.findByCommercialDistrictCode(commercialDistrictCode);
    }

    // 모든 상권 데이터 조회
    public List<CommDistEntity> getAllCommDistData() {
        return commDistRepository.findAll();
    }

    // 특정 조건에 따른 상권 데이터 조회
    // 지역 코드에 따라 조회
    public List<CommDistEntity> getCommDistByGuCode(Long guCode) {
        return commDistRepository.findByGuCode(guCode);
    }

    // 서울시 전체 상권을 조회 후 총점 기준으로 10개만 정렬
    public List<CommDistDTO> getTopCommDistByCoScore(int limit) {
        try {
            List<CommDistEntity> sortedEntities = commDistRepository.findAll()
                    .stream()
                    .sorted(Comparator.comparing(CommDistEntity::getCommercialDistrictScore).reversed())
                    .limit(limit)
                    .collect(Collectors.toList());
            return convertToDTOs(sortedEntities);
        } catch (Exception e) {
            log.error("서울시 전체 상권에서 랭킹을 가져오는데 실패하였습니다.");
            System.out.println(e);
        }
        return null;
    }

    // 자치구 기준으로 조회된 상권에서 coScore가 높은 순으로 10개를 찾아 내림차순 정렬
    public List<CommDistDTO> getTopCommDistByGuCodeAndCoScore(Long guCode, int limit) {
        try {
            Pageable topTen = PageRequest.of(0, limit, Sort.by("coScore").descending());
            Page<CommDistEntity> topEntities = commDistRepository.findTopByGuCode(guCode, topTen);
            return convertToDTOs(topEntities.getContent());
        } catch (Exception e) {
            log.error("자치구 기준으로 상권 랭킹을 가져오는데 실패하였습니다.");
            System.out.println(e);
        }
        return null;
    }
}