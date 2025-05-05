package org.gdsc.globook.application.dto;

import java.util.List;
import lombok.AccessLevel;
import lombok.Builder;

@Builder(access = AccessLevel.PRIVATE)
public record BookSearchResponseDto(
        List<BookThumbnailResponseDto> books
) {
    public static BookSearchResponseDto of(List<BookThumbnailResponseDto> books) {
        return BookSearchResponseDto.builder()
                .books(books)
                .build();
    }
}
