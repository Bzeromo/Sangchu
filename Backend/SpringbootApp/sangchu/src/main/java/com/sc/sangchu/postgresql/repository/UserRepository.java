package com.sc.sangchu.postgresql.repository;

import com.sc.sangchu.postgresql.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<UserEntity, Long> {
}
