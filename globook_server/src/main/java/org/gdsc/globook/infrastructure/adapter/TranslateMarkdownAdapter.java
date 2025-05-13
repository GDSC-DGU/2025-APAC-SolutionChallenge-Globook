package org.gdsc.globook.infrastructure.adapter;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.gemini.GeminiResponseDto;
import org.gdsc.globook.application.dto.gemini.TranslateGeminiRequestDto;
import org.gdsc.globook.application.port.TranslateMarkdownPort;
import org.gdsc.globook.core.util.RetryUtils;
import org.gdsc.globook.domain.type.ELanguage;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

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
        return RetryUtils.retry(() -> {
            GeminiResponseDto response = geminiRestClient.post()
                    .body(TranslateGeminiRequestDto.from(
                            "TRANSLATE TO " + targetLanguage.getLanguage() + markdown
                    ))
                    .retrieve()
                    .body(GeminiResponseDto.class);

            return response.candidates().getFirst().content().parts().getFirst().text();
        }, 5, 1000, true);
    }
}
