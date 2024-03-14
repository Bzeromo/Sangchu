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

//    // 새로운 상권 데이터 생성
//    public CommDistEntity createCommDist(CommDistDTO commDistDTO) {
//        // DTO를 엔티티로 변환하는 로직 필요
//        // ...
//
//        // 엔티티 저장
//        return commDistRepository.save(commDistEntity);
//    }

    public CommDistDTO convertToDTO(CommDistEntity entity) {

        CommDistDTO dto = new CommDistDTO();

        dto.setCoId(entity.getCoId());
        dto.setServiceCode(entity.getServiceCode());
        dto.setServiceName(entity.getServiceName());
        dto.setMajorCategoryCode(entity.getMajorCategoryCode());
        dto.setMajorCategoryName(entity.getMajorCategoryName());
        dto.setMiddleCategoryCode(entity.getMiddleCategoryCode());
        dto.setMiddleCategoryCode(entity.getMiddleCategoryName());
        dto.setCoName(entity.getCoName());
        dto.setGuCode(entity.getGuCode());
        dto.setGuName(entity.getGuName());
        dto.setDongCode(entity.getDongCode());
        dto.setDongName(entity.getDongName());
        dto.setCoArea(entity.getCoArea());
        dto.setCoX(entity.getCoX());
        dto.setCoY(entity.getCoY());
        dto.setCoScore(entity.getCoScore());
        dto.setCoSalesScore(entity.getCoSalesScore());
        dto.setCoFlPoScore(entity.getCoFlPoScore());
        dto.setCoRePoScore(entity.getCoRePoScore());
        dto.setCoCompScore(entity.getCoCompScore());
        dto.setCoDiversityScore(entity.getCoDiversityScore());

        return dto;
    }

    public List <CommDistDTO> convertToDTOs(List <CommDistEntity> commDistEntities) {

        List <CommDistDTO> dtoList = new ArrayList<>();

        if(!commDistEntities.isEmpty()) {
            CommDistEntity entity;

            for (CommDistEntity commDistEntity : commDistEntities) {
                CommDistDTO dto = new CommDistDTO();
                entity = commDistEntity;

                dto.setCoId(entity.getCoId());
                dto.setServiceCode(entity.getServiceCode());
                dto.setServiceName(entity.getServiceName());
                dto.setMajorCategoryCode(entity.getMajorCategoryCode());
                dto.setMajorCategoryName(entity.getMajorCategoryName());
                dto.setMiddleCategoryCode(entity.getMiddleCategoryCode());
                dto.setMiddleCategoryCode(entity.getMiddleCategoryName());
                dto.setCoName(entity.getCoName());
                dto.setGuCode(entity.getGuCode());
                dto.setGuName(entity.getGuName());
                dto.setDongCode(entity.getDongCode());
                dto.setDongName(entity.getDongName());
                dto.setCoArea(entity.getCoArea());
                dto.setCoX(entity.getCoX());
                dto.setCoY(entity.getCoY());
                dto.setCoScore(entity.getCoScore());
                dto.setCoSalesScore(entity.getCoSalesScore());
                dto.setCoFlPoScore(entity.getCoFlPoScore());
                dto.setCoRePoScore(entity.getCoRePoScore());
                dto.setCoCompScore(entity.getCoCompScore());
                dto.setCoDiversityScore(entity.getCoDiversityScore());

                dtoList.add(dto);
            }
        }

        return dtoList;
    }

    // 상권 데이터 조회 by coId
    public CommDistEntity getCommDistById(Integer coId) {
        return commDistRepository.findByCoId(coId);
    }

    // 모든 상권 데이터 조회
    public List<CommDistEntity> getAllCommDistData() {
        return commDistRepository.findAll();
    }

    // 특정 조건에 따른 상권 데이터 조회
    // 지역 코드에 따라 조회
    public List<CommDistEntity> getCommDistByGuCode(Integer guCode) {
        return commDistRepository.findByGuCode(guCode);
    }

    // 업종 코드에 따라 조회
    public List<CommDistEntity> getCommDistByServiceCode(String serviceCode) {
        return commDistRepository.findByServiceCode(serviceCode);
    }

    // 지역 및 업종 코드에 따라 조회
    public List<CommDistEntity> getCommDistByServiceCodeAndGuCode(String serviceCode, Integer guCode) {
        return commDistRepository.findByServiceCodeAndGuCode(serviceCode, guCode);
    }

    // 서울시 전체 상권을 조회 후 총점 기준으로 10개만 정렬
    public List<CommDistDTO> getTopCommDistByCoScore(int limit) {
        List<CommDistEntity> sortedEntities = commDistRepository.findAll()
                .stream()
                .sorted(Comparator.comparing(CommDistEntity::getCoScore).reversed())
                .limit(limit)
                .collect(Collectors.toList());
        return convertToDTOs(sortedEntities);
    }

    // 자치구 기준으로 조회된 상권에서 coScore가 높은 순으로 10개를 찾아 내림차순 정렬
    public List<CommDistDTO> getTopCommDistByGuCodeAndCoScore(int guCode, int limit) {
        Pageable topTen = PageRequest.of(0, limit, Sort.by("coScore").descending());
        Page<CommDistEntity> topEntities = commDistRepository.findTopByGuCode(guCode, topTen);
        return convertToDTOs(topEntities.getContent());
    }
}