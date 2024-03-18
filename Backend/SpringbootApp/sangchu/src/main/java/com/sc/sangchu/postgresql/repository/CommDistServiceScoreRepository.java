package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.postgresql.entity.CommDistEntity;
import com.sc.sangchu.postgresql.entity.CommDistServiceScoreEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommDistServiceScoreRepository extends JpaRepository<CommDistServiceScoreEntity, Integer> {
    // 특정 상권 코드 + 서비스 업종코드에 해당하는 상권 목록을 가져오는 메서드
    CommDistServiceScoreEntity findByCommercialDistrictCodeAndServiceCode(Long commercialDistrictCode, Long serviceCode);
    // 특정 자치구 코드에 해당하는 상권 목록을 가져오는 메서드
    List<CommDistServiceScoreEntity> findByGuCode(Long guCode);
    // 자치구 기준으로 조회된 상권에서 coScore가 높은 순으로 10개를 찾아 내림차순 정렬
    Page<CommDistServiceScoreEntity> findTopByGuCode(Long guCode, Pageable pageable);
}