package org.gdsc.globook.application.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class GeminiService {
    private final RestClient geminiRestClient;

    Map<String, Object> requestBody = Map.of(
            "contents", List.of(
                    Map.of("parts", List.of(
                            Map.of("text", """
                                    테스트입니다.
                                    """)
                    ))
            )
    );

    public void test(String test) {

        String response = geminiRestClient.post().body(requestBody).retrieve().body(String.class);

        log.info(response);
    }

}
