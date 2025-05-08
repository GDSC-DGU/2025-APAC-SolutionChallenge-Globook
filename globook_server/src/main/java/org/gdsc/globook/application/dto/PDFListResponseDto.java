package org.gdsc.globook.application.dto;

import java.util.List;
import lombok.AccessLevel;
import lombok.Builder;

@Builder(access = AccessLevel.PRIVATE)
public record PDFListResponseDto(
        List<PDFSummaryResponseDto> files
) {
    public static PDFListResponseDto of(List<PDFSummaryResponseDto> files) {
        return PDFListResponseDto.builder()
                .files(files)
                .build();
    }
}
