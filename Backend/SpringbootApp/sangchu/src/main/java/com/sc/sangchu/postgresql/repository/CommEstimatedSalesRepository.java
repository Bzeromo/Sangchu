package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.postgresql.entity.CommEstimatedSalesEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommEstimatedSalesRepository extends JpaRepository<CommEstimatedSalesEntity, Integer> {
    //특정 상권 코드의 데이터 조회
    List<CommEstimatedSalesEntity> findByCommercialDistrictCode(Long commercialDistrictCode);

    @Query("SELECT c " +
            "FROM CommEstimatedSalesEntity c " +
            "WHERE c.yearQuarterCode LIKE %:year% " +
            "and c.commercialDistrictCode = :commCode")
    List<CommEstimatedSalesEntity> findByStandardYear(@Param("commCode") Long commCode, @Param("year") int year);
}
