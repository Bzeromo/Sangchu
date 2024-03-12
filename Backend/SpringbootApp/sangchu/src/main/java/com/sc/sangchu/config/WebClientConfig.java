package com.sc.sangchu.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class WebClientConfig {

    @Bean
    public WebClient webClient(WebClient.Builder builder) {
        return builder
                .baseUrl("https://j10b206.p.ssafy.io") // 기본 URL 설정
                .build(); // WebClient 인스턴스 생성
    }
}
