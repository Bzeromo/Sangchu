package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.postgresql.entity.CommAptEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CommAptRepository extends JpaRepository<CommAptEntity, Integer> {
    CommAptEntity findByCommercialDistrictCode (Long commercialDistrictCode);
}
