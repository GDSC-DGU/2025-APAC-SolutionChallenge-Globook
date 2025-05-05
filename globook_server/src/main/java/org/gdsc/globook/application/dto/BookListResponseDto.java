package org.gdsc.globook.application.dto;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import lombok.AccessLevel;
import lombok.Builder;

@Builder(access = AccessLevel.PRIVATE)
public record BookListResponseDto(
        Map<String, List<BookThumbnailResponseDto>> booksByCategory
) {
    public static BookListResponseDto of(List<BookThumbnailResponseDto> books) {
        Map<String, List<BookThumbnailResponseDto>> grouped = books.stream()
                .collect(Collectors.groupingBy(BookThumbnailResponseDto::category));
        return BookListResponseDto.builder()
                .booksByCategory(grouped)
                .build();
    }
}
