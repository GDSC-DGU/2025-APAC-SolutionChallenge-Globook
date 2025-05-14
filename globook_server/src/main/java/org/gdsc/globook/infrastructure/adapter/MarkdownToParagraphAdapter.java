package org.gdsc.globook.infrastructure.adapter;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.gemini.GeminiResponseDto;
import org.gdsc.globook.application.dto.gemini.MarkdownToParagraphGeminiRequestDto;
import org.gdsc.globook.application.port.MarkdownToParagraphPort;
import org.gdsc.globook.core.util.RetryUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.io.IOException;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class MarkdownToParagraphAdapter implements MarkdownToParagraphPort {
    private final RestClient geminiRestClient;

    @Override
    public List<String> convertMarkdownToParagraph(String markdown) {
        log.info("마크다운을 각 문단별로 구분중");

        // 1. Gemini API 호출만 retry 대상
        GeminiResponseDto response = RetryUtils.retry(() -> {
            return geminiRestClient.post()
                    .body(MarkdownToParagraphGeminiRequestDto.from(markdown))
                    .retrieve()
                    .body(GeminiResponseDto.class);
        }, 5, 1000, true);

        // 2. 받은 응답 파싱 (이건 retry 대상 아님)
        try {
            ObjectMapper mapper = new ObjectMapper();
            return mapper.readValue(
                    response.candidates().getFirst().content().parts().getFirst().text(),
                    new TypeReference<List<String>>() {}
            );
        } catch (IOException e) {
            throw new RuntimeException("Gemini 응답 파싱 중 오류 발생 ----------- " + response.candidates().getFirst().content().parts().getFirst().text());
        }
    }
}
