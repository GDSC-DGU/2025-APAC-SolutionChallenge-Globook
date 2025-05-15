package org.gdsc.globook.infrastructure.adapter;

import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.PdfToMarkdownResponseDto;
import org.gdsc.globook.application.dto.PdfToMarkdownResponsePollingDto;
import org.gdsc.globook.application.port.PdfToMarkdownPort;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.client.MultipartBodyBuilder;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Slf4j
@Component
@RequiredArgsConstructor
public class PdfToMarkdownAdapter implements PdfToMarkdownPort {
    private final RestClient pdfRestClient;
    private final RestClient getMdRestClient;

    @Override
    public PdfToMarkdownResponseDto convertPdfToMarkdown(
            MultipartFile file
    ) {
        Resource fileResource = null;

        // 1. 파일을 Resource 로 변환
        try {
            fileResource = new ByteArrayResource(file.getBytes()) {
                @Override
                @NonNull
                public String getFilename() {
                    return file.getOriginalFilename();
                }
            };
        } catch (IOException e) {
            throw new RuntimeException("pdf to Byte 전환 중 예외 발생");
        }

        // 2. multipart/form-data 요청 바디 생성
        MultipartBodyBuilder builder = new MultipartBodyBuilder();
        builder.part("file", fileResource)
                .contentType(MediaType.APPLICATION_PDF);

        // 3. RestClient 로 전송
        PdfToMarkdownResponsePollingDto pollingDto = pdfRestClient.post()
                .contentType(MediaType.MULTIPART_FORM_DATA)
                .body(builder.build())
                .retrieve()
                .body(PdfToMarkdownResponsePollingDto.class);

        // 4. 성공했다면, polling 하여 PdfToMarkdownResponseDto 받아옴.
        if(pollingDto.success()) {
            log.info("pdf 마크다운 전환 성공 ---------- " + pollingDto.request_check_url());

            String checkUrl = pollingDto.request_check_url();
            PdfToMarkdownResponseDto response = null;

            int maxTry = 30;
            int intervalMs = 500;

            for (int i = 0; i < maxTry; i++) {
                log.info("polling ---------- " + i);

                response = getMdRestClient.get()
                        .uri(checkUrl)
                        .retrieve()
                        .body(PdfToMarkdownResponseDto.class);

                if (response.markdown() != null) {
                    break;
                }
                try {
                    Thread.sleep(intervalMs);
                } catch (InterruptedException e) {
                    // 1) 현재 스레드의 interrupted 상태 복구
                    Thread.currentThread().interrupt();

                    // 2) 루프를 깔끔히 빠져나가거나 상위로 전파
                    throw new RuntimeException("폴링 중 인터럽트됨");
                }
            }

            return response;
        } else {
            log.info("pdf 마크다운 전환 실패 ---------- " + pollingDto.error());

            throw new RuntimeException("마크다운 전환 실패");
        }
    }
}
