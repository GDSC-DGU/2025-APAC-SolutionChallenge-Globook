package org.gdsc.globook.application.dto;

import org.springframework.web.multipart.MultipartFile;

public record PdfToMarkdownRequestDto(
        MultipartFile file,
        String langs
) {
}
