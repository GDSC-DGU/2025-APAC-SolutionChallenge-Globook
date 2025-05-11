package org.gdsc.globook.infrastructure.adapter;

import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import lombok.RequiredArgsConstructor;
import org.gdsc.globook.application.dto.TTSRequestDto;
import org.gdsc.globook.application.dto.TTSResponseDto;
import org.gdsc.globook.application.dto.UploadPdfRequestDto;
import org.gdsc.globook.application.dto.gemini.GeminiResponseDto;
import org.gdsc.globook.application.dto.gemini.GeneralizeParagraphRequestDto;
import org.gdsc.globook.application.port.TTSPort;
import org.gdsc.globook.domain.type.ELanguage;
import org.gdsc.globook.domain.type.EPersona;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.Base64;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class TTSAdapter implements TTSPort {
    @Value("${cloud.storage.bucket}")
    private String BUCKET_NAME;
    private final Storage storage;
    private final RestClient ttsRestClient;
    private final RestClient geminiRestClient;

    @Override
    public String convertTextToSpeech(
            Long userId,
            Long fileId,
            String inputText,
            Long paragraphId,
            UploadPdfRequestDto request
    ) {
        // 1. 문자열을 일반화
        inputText = generalizeString(inputText);

        // 2. 일반화된 문자열에 대해 TTS
        TTSRequestDto ttsRequestDto = TTSRequestDto.from(
                inputText,
                ELanguage.valueOf(request.targetLanguage()),
                EPersona.valueOf(request.persona())
        );

        ResponseEntity<TTSResponseDto> response = ttsRestClient.post()
                .body(ttsRequestDto)
                .retrieve()
                .toEntity(TTSResponseDto.class);

        if (response.getStatusCode() == HttpStatus.OK) {
            return uploadAudio(
                    userId,
                    fileId,
                    Base64.getDecoder().decode(response.getBody().audioContent()),
                    "문단 번호" + paragraphId
            );
        } else {
            throw new IllegalStateException("TTS API 호출 실패: " + response.getStatusCode()); // 커스텀 에러로 변경해야 함
        }
    }

    private String uploadAudio(
            Long userId,
            Long fileId,
            byte[] audio,
            String audioName
    ) {
        UUID uuid = UUID.randomUUID();
        String objectName = "user " + userId + "/" + "file " + fileId + "/audio/" + audioName + uuid + ".mp3";

        BlobInfo blobInfo = BlobInfo.newBuilder(BUCKET_NAME, objectName)
                .setContentType("audio/mpeg")
                .build();
        storage.create(blobInfo, audio);

        return String.format("https://storage.googleapis.com/%s/%s", BUCKET_NAME, objectName);
    }

    private String generalizeString(String markdown) {
        GeminiResponseDto response = geminiRestClient.post()
                .body(GeneralizeParagraphRequestDto.from(markdown))
                .retrieve()
                .body(GeminiResponseDto.class);

        return response.candidates().getFirst().content().parts().getFirst().text();
    }
}
