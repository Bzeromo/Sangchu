package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.postgresql.entity.CommWorkingPopulationEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommWorkingPopulationRepository extends JpaRepository<CommWorkingPopulationEntity, Integer> {
    CommWorkingPopulationEntity findByCommercialDistrictCodeAndYearCodeAndQuarterCode(Long commCode, Integer year, Integer quarter);
    List<CommWorkingPopulationEntity> findAllByCommercialDistrictCode(Long commCode);
}
