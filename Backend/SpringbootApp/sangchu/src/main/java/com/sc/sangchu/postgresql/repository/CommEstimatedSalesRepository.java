package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.dto.sales.CommQuarterlyGraphDTO;
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

    List<CommEstimatedSalesEntity> findByYearCodeAndCommercialDistrictCodeAndMajorCategoryName(int year, Long commCode, String majorCategory);

    @Query("""
            SELECT new com.sc.sangchu.dto.sales.CommQuarterlyGraphDTO(c.yearCode, c.quarterCode, sum(c.weekDaysSales), sum(c.weekendSales))
            FROM CommEstimatedSalesEntity c
            WHERE c.commercialDistrictCode = :commCode
            AND c.majorCategoryName = :majorCategory
            AND c.yearCode IN :year
            GROUP BY c.yearCode, c.quarterCode
            ORDER BY c.yearCode, c.quarterCode""")
    List<CommQuarterlyGraphDTO> findByQuarterlyData(@Param("commCode")Long commCode, @Param("majorCategory") String majorCategory,
                                                    @Param("year")int[] year);

    CommEstimatedSalesEntity findByYearCodeAndQuarterCodeAndCommercialDistrictCodeAndServiceCode(int year, int quarter, Long commCode, String serviceCode);
}
