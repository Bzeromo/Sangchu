package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.postgresql.entity.CommStoreEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CommStoreRepository extends JpaRepository<CommStoreEntity, Integer> {

}
