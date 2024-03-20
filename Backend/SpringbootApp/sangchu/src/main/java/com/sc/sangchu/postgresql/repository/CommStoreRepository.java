package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.postgresql.entity.CommStoreEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommStoreRepository extends JpaRepository<CommStoreEntity, Integer> {
    List<CommStoreEntity> findByCommercialDistrictCodeAndYearCodeAndQuarterCode(
            Long commercialDistrictCode, Integer year, Integer quarter);

    CommStoreEntity findByCommercialDistrictCodeAndYearCodeAndQuarterCodeAndServiceCode(
            Long commercialDistrictCode, Integer year, Integer quarter, String serviceCode
    );
}
