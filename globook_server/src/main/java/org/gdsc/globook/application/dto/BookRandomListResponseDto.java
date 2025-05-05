package org.gdsc.globook.application.dto;

import java.util.List;
import lombok.AccessLevel;
import lombok.Builder;

@Builder(access = AccessLevel.PRIVATE)
public record BookRandomListResponseDto(
        List<BookThumbnailResponseDto> randomBooks
) {
    public static BookRandomListResponseDto of(List<BookThumbnailResponseDto> randomBooks) {
        return BookRandomListResponseDto.builder()
                .randomBooks(randomBooks)
                .build();
    }
}
