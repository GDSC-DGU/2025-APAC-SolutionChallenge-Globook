package org.gdsc.globook.infrastructure.adapter;

import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.PdfToMarkdownResponseDto;
import org.gdsc.globook.application.dto.PdfToMarkdownResultDto;
import org.gdsc.globook.application.dto.gemini.GeminiResponseDto;
import org.gdsc.globook.application.dto.gemini.TranslateGeminiRequestDto;
import org.gdsc.globook.application.port.TranslateMarkdownPort;
import org.gdsc.globook.domain.type.ELanguage;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;

@Slf4j
@Component
@RequiredArgsConstructor
public class TranslateMarkdownAdapter implements TranslateMarkdownPort {
    private final RestClient geminiRestClient;

    @Override
    public String translateMarkdown(
            Long userId,
            Long fileId,
            String markdown,
            ELanguage targetLanguage
    ) {
        log.info("마크다운을 번역중");
        // 마크다운을 번역중
        GeminiResponseDto response = geminiRestClient.post()
                .body(TranslateGeminiRequestDto.from(markdown + "\n\n\n TRANSLATE TO " + targetLanguage.getLanguage()))
                .retrieve()
                .body(GeminiResponseDto.class);

        String filePath = Paths.get("/Users/mj/Desktop/log/gemini_translate.txt").toString();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            writer.write(response.toString());
        } catch (IOException e) {

        }

        return response.candidates().getFirst().content().parts().getFirst().text();
    }

}
