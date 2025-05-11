package org.gdsc.globook.application.dto;

import lombok.Builder;

import java.util.Map;

@Builder
public record PdfToMarkdownResultDto(
        String markdown,
        Boolean success,
        Map<String, String> images,
        Long fileId
) {
    public static PdfToMarkdownResultDto of(PdfToMarkdownResponseDto pdfToMarkdownResponseDto, Long fileId) {
        return PdfToMarkdownResultDto.builder()
                .markdown(pdfToMarkdownResponseDto.markdown())
                .success(pdfToMarkdownResponseDto.success())
                .images(pdfToMarkdownResponseDto.images())
                .fileId(fileId)
                .build();
    }
}
