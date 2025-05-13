package org.gdsc.globook.infrastructure.adapter;

import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.port.ConvertImageToUrlPort;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;

@Slf4j
@Component
@RequiredArgsConstructor
public class GCSImageToUrlConverter implements ConvertImageToUrlPort {
    @Value("${cloud.storage.bucket}")
    private String BUCKET_NAME;
    private final Storage storage;

    @Override
    public String convertImageToUrl(
            Long userId,
            Long fileId,
            String markdown,
            Map<String, String> images
    ) {
        log.info("이미지를 S3 저장 후 url 을 넘겨받는 중");
        Map<String, String> uploaded = new HashMap<>();

        // 1. 전체 이미지 업로드
        for (Map.Entry<String,String> entry : images.entrySet()) {
            String fileName = entry.getKey();
            String base64Body = entry.getValue();

            byte[] data = Base64.getDecoder().decode(base64Body);
            String url = uploadImage(userId, fileId, data, fileName);
            uploaded.put(fileName, url);
        }

        // 2. 마크다운에서 파일명을 url 로 치환
        for (Map.Entry<String,String> entry : uploaded.entrySet()) {
            String fileName = Pattern.quote(entry.getKey());
            String url = entry.getValue();

            markdown = markdown.replaceAll("!\\[[^\\]]*]\\(" + fileName + "\\)", "![](" + url + ")");
        }

        return markdown;
    }

    private String uploadImage(
            Long userId,
            Long fileId,
            byte[] image,
            String imageName
    ) {
        UUID uuid = UUID.randomUUID();
        String objectName = "user" + userId + "/" + "file" + fileId + "/image/" + imageName + uuid;

        BlobInfo blobInfo = BlobInfo.newBuilder(BUCKET_NAME, objectName)
                .setContentType(probeContentType(imageName))
                .build();
        storage.create(blobInfo, image);

        return String.format("https://storage.googleapis.com/%s/%s", BUCKET_NAME, objectName);
    }

    private String probeContentType(String name) {
        String ext = name.substring(name.lastIndexOf('.') + 1).toLowerCase();
        return switch (ext) {
            case "png"  -> "image/png";
            case "jpg", "jpeg" -> "image/jpeg";
            case "gif"  -> "image/gif";
            case "bmp"  -> "image/bmp";
            case "webp" -> "image/webp";
            default     -> "application/octet-stream";
        };
    }
}
