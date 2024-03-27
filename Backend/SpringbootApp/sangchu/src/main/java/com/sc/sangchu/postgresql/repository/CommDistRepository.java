package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.dto.CommDistSetRankDTO;
import com.sc.sangchu.postgresql.entity.CommDistEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CommDistRepository extends JpaRepository<CommDistEntity, Integer> {
    // 특정 상권 코드에 해당하는 상권 목록을 가져오는 메서드
    CommDistEntity findByCommercialDistrictCode(Long commercialDistrictCode);
    // 특정 자치구 코드에 해당하는 상권 목록을 가져오는 메서드
    List<CommDistEntity> findByGuCode(Long guCode);

//    @Query("""
//            SELECT new com.sc.sangchu.dto.CommDistSetRankDTO(c.commercialDistrictCode ,row_number() over (order by commercialDistrictScore))
//              FROM CommDistEntity c
//            """
//    )
    @Query("""
            SELECT new com.sc.sangchu.dto.CommDistSetRankDTO(c.commercialDistrictCode ,row_number() over (order by c.commercialDistrictScore))
              FROM CommDistEntity c 
            """
    )
    List<CommDistSetRankDTO> findAllByCommercialDistrictCode();
}