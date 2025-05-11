package org.gdsc.globook.application.dto;

import java.util.List;

public record ParagraphListResponseDto(
        List<ParagraphResponseDto> paragraphList
) {
}
