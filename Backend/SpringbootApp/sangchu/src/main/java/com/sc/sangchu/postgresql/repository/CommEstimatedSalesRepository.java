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

    @Query("SELECT c " +
            "FROM CommEstimatedSalesEntity c " +
            "WHERE c.yearCode = %:year% " +
            "and c.commercialDistrictCode = :commCode " +
            "and c.majorCategoryName = :majorCategory ")
    List<CommEstimatedSalesEntity> findByStandardYear(@Param("commCode") Long commCode, @Param("year") int year,
                                                      @Param("majorCategory") String majorCategory);

    @Query(
            "SELECT new com.sc.sangchu.dto.sales.CommQuarterlyGraphDTO(c.yearCode, c.quarterCode, sum(c.weekDaysSales), sum(c.weekendSales))\n" +
            "FROM CommEstimatedSalesEntity c \n" +
            "WHERE c.commercialDistrictCode = :commCode\n" +
            "AND c.majorCategoryName = :majorCategory\n" +
            "AND c.yearCode IN :year\n" +
            "GROUP BY c.yearCode, c.quarterCode\n" +
            "ORDER BY c.yearCode, c.quarterCode \n")
    List<CommQuarterlyGraphDTO> findByQuarterlyData(@Param("commCode")Long commCode, @Param("majorCategory") String majorCategory,
                                                    @Param("year")int[] year);
}
