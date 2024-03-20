package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.postgresql.entity.CommIncomeEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommIncomeRepository extends JpaRepository<CommIncomeEntity, Integer> {
    List<CommIncomeEntity> findAllByYearCodeAndQuarterCode (Integer year, Integer quarter);
    CommIncomeEntity findByCommercialDistrictCodeAndYearCodeAndQuarterCode (Long commCode, Integer year, Integer quarter);
}
