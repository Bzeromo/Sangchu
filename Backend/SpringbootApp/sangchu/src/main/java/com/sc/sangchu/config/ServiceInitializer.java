package com.sc.sangchu.config;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.data.redis.core.RedisTemplate;
import javax.sql.DataSource;
import java.sql.Connection;

@Component
public class ServiceInitializer {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    @PostConstruct
    public void waitForServices() {
        waitForPostgres();
        waitForRedis();
    }

    private void waitForPostgres() {
        boolean connected = false;
        while (!connected) {
            try (Connection conn = dataSource.getConnection()) {
                if (conn != null) {
                    System.out.println("Successfully connected to PostgreSQL.");
                    connected = true;
                }
            } catch (Exception e) {
                System.out.println("Waiting for PostgreSQL to be ready...");
                try {
                    Thread.sleep(5000); // 5초 대기
                } catch (InterruptedException ie) {
                    Thread.currentThread().interrupt();
                }
            }
        }
    }

    private void waitForRedis() {
        while (true) {
            try {
                String response = redisTemplate.getConnectionFactory().getConnection().ping();
                if ("PONG".equals(response)) {
                    System.out.println("Successfully connected to Redis.");
                    break;
                }
            } catch (Exception e) {
                System.out.println("Waiting for Redis to be ready...");
                try {
                    Thread.sleep(5000); // 5초 대기
                } catch (InterruptedException ie) {
                    Thread.currentThread().interrupt();
                }
            }
        }
    }
}
