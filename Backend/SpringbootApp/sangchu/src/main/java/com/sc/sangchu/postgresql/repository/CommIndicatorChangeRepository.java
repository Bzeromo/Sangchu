package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.postgresql.entity.CommIndicatorChangeEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommIndicatorChangeRepository extends JpaRepository<CommIndicatorChangeEntity, Integer> {
    // 조회
    CommIndicatorChangeEntity findByCommercialDistrictCode (Long commercialDistrictCode);
}
