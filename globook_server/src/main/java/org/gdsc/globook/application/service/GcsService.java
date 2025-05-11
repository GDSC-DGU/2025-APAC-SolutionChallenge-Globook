package org.gdsc.globook.application.service;


import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class GcsService {
    @Value("${cloud.storage.bucket}")
    private String BUCKET_NAME;
    private final Storage storage;

    public void uploadFile(MultipartFile file) throws IOException {
        String fileName = file.getOriginalFilename();
        UUID uuid = UUID.randomUUID();

        BlobInfo blobInfo = BlobInfo.newBuilder(BUCKET_NAME, fileName + uuid)
                .setContentType(file.getContentType())
                .build();

        storage.create(blobInfo, file.getBytes());
    }

    public String getPublicImageUrl(String fileName) {
        return String.format("https://storage.googleapis.com/%s/%s", BUCKET_NAME, fileName);
    }
}