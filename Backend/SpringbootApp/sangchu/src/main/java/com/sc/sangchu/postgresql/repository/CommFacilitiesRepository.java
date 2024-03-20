package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.postgresql.entity.CommFacilitiesEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CommFacilitiesRepository extends JpaRepository<CommFacilitiesEntity, Integer> {
    CommFacilitiesEntity findByCommercialDistrictCodeAndYearCodeAndQuarterCode(Long commercialDistrictCode, Integer year, Integer quarter);
}
