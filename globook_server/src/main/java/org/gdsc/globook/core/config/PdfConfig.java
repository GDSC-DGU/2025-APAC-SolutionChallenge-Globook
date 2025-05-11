package org.gdsc.globook.core.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

@Configuration
public class PdfConfig {
    @Value("${pdf.api.key}")
    private String pdfApiKey;

    @Value("${pdf.api.url}")
    private String pdfUrl;

    @Bean
    public RestClient pdfRestClient() {
        return RestClient.builder()
                .baseUrl(pdfUrl)
                .defaultHeader("X-Api-Key", pdfApiKey)
                .defaultHeader("Content-Type", "application/json")
                .build();
    }

    @Bean
    public RestClient getMdRestClient() {
        return RestClient.builder()
                .defaultHeader("X-Api-Key", pdfApiKey)
                .defaultHeader("Content-Type", "application/json")
                .build();
    }
}
