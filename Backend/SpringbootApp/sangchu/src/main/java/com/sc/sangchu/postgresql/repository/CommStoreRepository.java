package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.dto.infra.CommStoreTotalCountDTO;
import com.sc.sangchu.postgresql.entity.CommStoreEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommStoreRepository extends JpaRepository<CommStoreEntity, Integer> {
    List<CommStoreEntity> findByCommercialDistrictCodeAndYearCodeAndQuarterCode(
            Long commercialDistrictCode, Integer year, Integer quarter);

    CommStoreEntity findByCommercialDistrictCodeAndYearCodeAndQuarterCodeAndServiceCode(
            Long commercialDistrictCode, Integer year, Integer quarter, String serviceCode
    );

    @Query("""
            SELECT new com.sc.sangchu.dto.infra.CommStoreTotalCountDTO(c.commercialDistrictCode, SUM(c.storeCount))
            FROM CommStoreEntity c
            WHERE c.commercialDistrictCode = :commCode
            AND c.yearCode = :year
            AND c.quarterCode = :quarter
            GROUP BY c.commercialDistrictCode
            """)
    CommStoreTotalCountDTO findStoreTotalCount(@Param("year")Integer year, @Param("quarter") Integer quarter,
                                               @Param("commCode")Long commCode);
}
