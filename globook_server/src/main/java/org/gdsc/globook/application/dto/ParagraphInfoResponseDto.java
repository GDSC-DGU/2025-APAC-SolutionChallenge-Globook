package org.gdsc.globook.application.dto;

import lombok.AccessLevel;
import lombok.Builder;
import org.gdsc.globook.domain.type.ELanguage;
import org.gdsc.globook.domain.type.EPersona;


@Builder(access = AccessLevel.PRIVATE)
public record ParagraphInfoResponseDto(
        Long id,
        Long maxIndex,
        String targetLanguage,
        String persona
) {
    public static ParagraphInfoResponseDto of(Long id, Long maxIndex, ELanguage targetLanguage, EPersona persona) {
        return ParagraphInfoResponseDto.builder()
                .id(id)
                .maxIndex(maxIndex)
                .targetLanguage(String.valueOf(targetLanguage))
                .persona(String.valueOf(persona))
                .build();
    }
}
