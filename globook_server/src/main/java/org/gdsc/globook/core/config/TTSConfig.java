package org.gdsc.globook.core.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

@Configuration
public class TTSConfig {
    @Value("${tts.api.key}")
    private String ttsApiKey;

    @Value("${tts.api.url}")
    private String ttsUrl;

    @Bean
    public RestClient ttsRestClient() {
        return RestClient.builder()
                .baseUrl(ttsUrl + ttsApiKey)
                .defaultHeader("Content-Type", "application/json")
                .build();
    }
}
