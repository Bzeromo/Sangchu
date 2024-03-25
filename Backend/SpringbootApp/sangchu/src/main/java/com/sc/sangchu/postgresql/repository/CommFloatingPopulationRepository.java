package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.postgresql.entity.CommFloatingPopulationEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommFloatingPopulationRepository extends JpaRepository<CommFloatingPopulationEntity, Integer> {
    CommFloatingPopulationEntity findByCommercialDistrictCodeAndYearCodeAndQuarterCode(Long commCode, Integer year, Integer quarter);
    List<CommFloatingPopulationEntity> findAllByCommercialDistrictCode(Long commCode);

    List<CommFloatingPopulationEntity> findByYearAndQuarterCodeAndCommercialDistrictCode(int year, int quarter, List<Long> commList);
}
