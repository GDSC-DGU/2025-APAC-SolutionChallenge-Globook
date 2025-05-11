package org.gdsc.globook.application.dto;

import java.util.List;
import lombok.Builder;

@Builder
public record ParagraphListResponseDto(
        ParagraphInfoResponseDto paragraphsInfo,
        List<ParagraphResponseDto> paragraphList
) {
}
