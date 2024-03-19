package com.sc.sangchu.postgresql.service;

import com.sc.sangchu.dto.CommDistDTO;
import com.sc.sangchu.postgresql.entity.CommDistEntity;
import com.sc.sangchu.postgresql.repository.CommDistRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
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
        dto.setAreaCode(entity.getAreaCode());
        dto.setCoArea(entity.getCoArea());
        dto.setCoX(entity.getCoX());
        dto.setCoY(entity.getCoY());
        dto.setCoScore(entity.getCoScore());
        dto.setCoApart(entity.getCoApart());
        dto.setCoIncome(entity.getCoIncome());
        dto.setCoConsump(entity.getCoConsump());
        dto.setCoChangeIndex(entity.getCoChangeIndex());
        dto.setCoSales(entity.getCoSales());
        dto.setCoSalesScore(entity.getCoSalesScore());
        dto.setCoFlPo(entity.getCoFlPo());
        dto.setCoFlPoScore(entity.getCoFlPoScore());
        dto.setCoRePo(entity.getCoRePo());
        dto.setCoRePoScore(entity.getCoRePoScore());
        dto.setCoWoPo(entity.getCoWoPo());
        dto.setCoCompScore(entity.getCoCompScore());
        dto.setCoDiversityScore(entity.getCoDiversityScore());

        return dto;
    }

    public List <CommDistDTO> convertToDTOs(List <CommDistEntity> commDistEntities) {

        List <CommDistDTO> dtoList = new ArrayList<>();

        if(!commDistEntities.isEmpty()) {
            int row_cnt = commDistEntities.size();
            CommDistEntity entity;

            for(int i = 0; i < row_cnt; i++) {
                CommDistDTO dto = new CommDistDTO();
                entity = commDistEntities.get(i);

                dto.setCoId(entity.getCoId());
                dto.setAreaCode(entity.getAreaCode());
                dto.setCoArea(entity.getCoArea());
                dto.setCoX(entity.getCoX());
                dto.setCoY(entity.getCoY());
                dto.setCoScore(entity.getCoScore());
                dto.setCoApart(entity.getCoApart());
                dto.setCoIncome(entity.getCoIncome());
                dto.setCoConsump(entity.getCoConsump());
                dto.setCoChangeIndex(entity.getCoChangeIndex());
                dto.setCoSales(entity.getCoSales());
                dto.setCoSalesScore(entity.getCoSalesScore());
                dto.setCoFlPo(entity.getCoFlPo());
                dto.setCoFlPoScore(entity.getCoFlPoScore());
                dto.setCoRePo(entity.getCoRePo());
                dto.setCoRePoScore(entity.getCoRePoScore());
                dto.setCoWoPo(entity.getCoWoPo());
                dto.setCoCompScore(entity.getCoCompScore());
                dto.setCoDiversityScore(entity.getCoDiversityScore());

                dtoList.add(dto);
            }
        }


        return dtoList;
    }

    // 상권 데이터 조회 by coId
    public CommDistEntity getCommDistById(int coId) {
        return commDistRepository.findByCoId(coId);
    }

    // 모든 상권 데이터 조회
    public List<CommDistEntity> getAllCommDistData() {
        return commDistRepository.findAll();
    }

    // 특정 조건에 따른 상권 데이터 조회
    // 지역 코드에 따라 조회
    public List<CommDistEntity> getCommDistByAreaCode(int areaCode) {
        return commDistRepository.findByAreaCode(areaCode);
    }

//    // 상권 데이터 업데이트
//    public CommDistEntity updateCommDist(int coId, CommDistDTO commDistDTO) {
//        // 엔티티 조회 및 업데이트 로직 필요
//        // ...
//
//        // 엔티티 저장
//        return commDistRepository.save(commDistEntity);
//    }
//
//    // 상권 데이터 삭제
//    public void deleteCommDist(int coId) {
//        commDistRepository.deleteById(coId);
//    }

//    // 상권 데이터의 특정 필드 업데이트
//    // 예: coSales 필드 업데이트
//    public CommDistEntity updateCoSales(int coId, int coSales) {
//        CommDistEntity commDist = commDistRepository.findByCoId(coId)
//                .orElseThrow(() -> new RuntimeException("CommDist not found with coId: " + coId));
//
//        commDist.setCoSales(coSales);
//        return commDistRepository.save(commDist);
//    }
}