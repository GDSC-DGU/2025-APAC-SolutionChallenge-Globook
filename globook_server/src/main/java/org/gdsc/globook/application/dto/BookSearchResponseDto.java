package org.gdsc.globook.application.dto;

import java.util.List;
import lombok.AccessLevel;
import lombok.Builder;

// 도서 찾기랑 보관함 다운로드한 도서 리스트 조회에서 사용
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
