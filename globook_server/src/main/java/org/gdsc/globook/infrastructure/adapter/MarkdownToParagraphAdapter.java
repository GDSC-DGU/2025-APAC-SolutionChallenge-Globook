package org.gdsc.globook.infrastructure.adapter;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.gemini.GeminiResponseDto;
import org.gdsc.globook.application.dto.gemini.MarkdownToParagraphGeminiRequestDto;
import org.gdsc.globook.application.port.MarkdownToParagraphPort;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class MarkdownToParagraphAdapter implements MarkdownToParagraphPort {
    private final RestClient geminiRestClient;

    @Override
    public List<String> convertMarkdownToParagraph(String markdown) {
        log.info("마크다운을 각 문단별로 구분중");

        // 1. 전체 문단에 대한 파싱 요청을 보냄
        GeminiResponseDto response = geminiRestClient.post()
                .body(MarkdownToParagraphGeminiRequestDto.from(markdown))
                .retrieve()
                .body(GeminiResponseDto.class);

        log.info(response.toString());
        // 2. response 를 매핑 후 return
        ObjectMapper mapper = new ObjectMapper();
        try {
            List<String> list = mapper.readValue(
                    response.candidates().getFirst().content().parts().getFirst().text(),
                    new TypeReference<List<String>>() {}
            );

            return list;
        } catch (IOException e) {
            throw new RuntimeException("문자열 mapping 중 예외 발생");
        }
    }
}
