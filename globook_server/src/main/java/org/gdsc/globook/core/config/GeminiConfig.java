package org.gdsc.globook.core.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

@Configuration
public class GeminiConfig {
    @Value("${gemini.api.key}")
    private String geminiAiKey;

    @Value("${gemini.api.url}")
    private String geminiUrl;

    @Bean
    public RestClient geminiRestClient() {
        return RestClient.builder()
                .baseUrl(geminiUrl + geminiAiKey)
                .defaultHeader("Content-Type", "application/json")
                .build();
    }
}