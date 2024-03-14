package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.postgresql.entity.CommDistEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommDistRepository extends JpaRepository<CommDistEntity, Integer> {
    // 특정 상권 코드에 해당하는 상권 목록을 가져오는 메서드
    CommDistEntity findByCoId(Long coId);
    // 특정 자치구 코드에 해당하는 상권 목록을 가져오는 메서드
    List<CommDistEntity> findByGuCode(Long guCode);
    // 특정 업종 코드에 해당하는 상권 목록을 가져오는 메서드
    //List<CommDistEntity> findByServiceCode(String serviceCode);
    // 특정 업종 코드에 해당하는 상권 목록을 가져오는 메서드
    //List<CommDistEntity> findByServiceCodeAndGuCode(String serviceCode, Long guCode);
    // 자치구 기준으로 조회된 상권에서 coScore가 높은 순으로 10개를 찾아 내림차순 정렬
    //Page<CommDistEntity> findTopByGuCode(Long guCode, Pageable pageable);
}