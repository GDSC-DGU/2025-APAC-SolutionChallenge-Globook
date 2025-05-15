package org.gdsc.globook.infrastructure.adapter;

import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.TTSRequestDto;
import org.gdsc.globook.application.dto.TTSResponseDto;
import org.gdsc.globook.application.dto.gemini.GeminiResponseDto;
import org.gdsc.globook.application.dto.gemini.GeneralizeParagraphRequestDto;
import org.gdsc.globook.application.port.TTSPort;
import org.gdsc.globook.core.util.RetryUtils;
import org.gdsc.globook.domain.type.ELanguage;
import org.gdsc.globook.domain.type.EPersona;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatusCode;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.Base64;
import java.util.UUID;

@Slf4j
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
            Long paragraphId,
            String inputText,
            String targetLanguage,
            String persona
    ) {
        log.info("문자열을 일반 문자열로 변환 후 번역 중");

        // 1. 문자열을 일반화
        inputText = generalizeString(inputText);

        // 2. 일반화된 문자열에 대해 TTS
        TTSRequestDto ttsRequestDto = TTSRequestDto.from(
                inputText,
                ELanguage.valueOf(targetLanguage),
                EPersona.valueOf(persona)
        );

        TTSResponseDto ttsResponse = RetryUtils.retry(() ->
                        ttsRestClient.post()
                                .body(ttsRequestDto)
                                .retrieve()
                                .onStatus(HttpStatusCode::isError,
                                        (req, res) -> new IllegalStateException("TTS 호출 실패: " + res.getStatusCode() + " 입력: " + ttsRequestDto.input()))
                                .body(TTSResponseDto.class),
                5, 1000, true);

        if(ttsResponse.audioContent() == null) {
            log.info(ttsResponse.toString());
            return "";
        } else {
            return uploadAudio(
                    userId,
                    fileId,
                    Base64.getDecoder().decode(ttsResponse.audioContent()),
                    "문단 번호" + paragraphId
            );
        }
    }

    private String uploadAudio(
            Long userId,
            Long fileId,
            byte[] audio,
            String audioName
    ) {
        UUID uuid = UUID.randomUUID();
        String objectName = "user" + userId + "/" + "file" + fileId + "/audio/" + audioName + uuid + ".mp3";

        BlobInfo blobInfo = BlobInfo.newBuilder(BUCKET_NAME, objectName)
                .setContentType("audio/mpeg")
                .build();
        storage.create(blobInfo, audio);

        return String.format("https://storage.googleapis.com/%s/%s", BUCKET_NAME, objectName);
    }

    private String generalizeString(String markdown) {
        GeminiResponseDto response = RetryUtils.retry(() -> {
            return geminiRestClient.post()
                    .body(GeneralizeParagraphRequestDto.from(markdown))
                    .retrieve()
                    .body(GeminiResponseDto.class);
        }, 5, 1000, true);

        return response.candidates().getFirst().content().parts().getFirst().text();
    }

}
