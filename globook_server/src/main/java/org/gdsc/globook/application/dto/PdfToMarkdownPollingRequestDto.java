package org.gdsc.globook.application.dto;

import java.util.Map;

public record PdfToMarkdownPollingRequestDto(
        String markdown,
        Boolean success,
        Map<String, String> images,
        String targetLanguage,
        String persona
) {
}
