package org.gdsc.globook.application.dto;

import java.util.Map;

public record PdfToMarkdownResponseDto(
        String markdown,
        Boolean success,
        Map<String, String> images
) {
}
