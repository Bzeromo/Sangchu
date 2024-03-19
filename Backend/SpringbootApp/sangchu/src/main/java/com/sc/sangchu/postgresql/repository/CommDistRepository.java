package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.postgresql.entity.CommDistEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommDistRepository extends JpaRepository<CommDistEntity, Integer> {
    CommDistEntity findByCoId(int coId);
    // 특정 지역 코드에 해당하는 상권 목록을 가져오는 메서드
    List<CommDistEntity> findByAreaCode(int areaCode);
}