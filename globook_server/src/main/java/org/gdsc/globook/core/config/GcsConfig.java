package org.gdsc.globook.core.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;

@Configuration
public class GcsConfig {
    @Value("${cloud.storage.credentials.location}")
    private String resourceJson;

    @Value("${cloud.storage.project-id}")
    private String projectId;

    @Bean
    public Storage storage() throws IOException {
        ClassPathResource resource = new ClassPathResource(resourceJson);
        GoogleCredentials credentials = GoogleCredentials.fromStream(resource.getInputStream());

        return StorageOptions.newBuilder()
                .setProjectId(projectId)
                .setCredentials(credentials)
                .build()
                .getService();
    }
}