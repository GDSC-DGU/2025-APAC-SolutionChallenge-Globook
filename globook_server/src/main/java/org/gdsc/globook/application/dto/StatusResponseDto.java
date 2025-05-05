package org.gdsc.globook.application.dto;

import lombok.AccessLevel;
import lombok.Builder;
import org.gdsc.globook.domain.type.EFileStatus;
import org.gdsc.globook.domain.type.EUserBookStatus;

@Builder(access = AccessLevel.PRIVATE)
public record StatusResponseDto(
        String status
) {
    public static StatusResponseDto of(EUserBookStatus status) {
        return StatusResponseDto.builder()
                .status(String.valueOf(status))
                .build();
    }

    public static StatusResponseDto of(EFileStatus status) {
        return StatusResponseDto.builder()
                .status(String.valueOf(status))
                .build();
    }
}
