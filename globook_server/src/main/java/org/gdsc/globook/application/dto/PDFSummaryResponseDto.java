package org.gdsc.globook.application.dto;

import lombok.AccessLevel;
import lombok.Builder;
import org.gdsc.globook.domain.entity.File;

@Builder(access = AccessLevel.PRIVATE)
public record PDFSummaryResponseDto(
        Long id,
        String title,
        String language,
        String fileStatus,
        String createdAt
) {
    public static PDFSummaryResponseDto of(File file) {
        return PDFSummaryResponseDto.builder()
                .id(file.getId())
                .title(file.getTitle())
                .language(String.valueOf(file.getLanguage()))
                .fileStatus(String.valueOf(file.getFileStatus()))
                .createdAt(String.valueOf(file.getCreatedAt()))
                .build();
    }
}
