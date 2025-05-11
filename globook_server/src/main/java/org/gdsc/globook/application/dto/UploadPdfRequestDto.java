package org.gdsc.globook.application.dto;

public record UploadPdfRequestDto(
        String targetLanguage,
        String persona
) {
}
