package org.gdsc.globook.application.dto;

import lombok.Builder;

@Builder
public record ParagraphResponseDto(
        Long index,
        String text,
        String voiceFile
) {
}
