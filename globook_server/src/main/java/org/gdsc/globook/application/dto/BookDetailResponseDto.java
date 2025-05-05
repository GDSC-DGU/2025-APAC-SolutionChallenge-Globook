package org.gdsc.globook.application.dto;

import java.util.List;
import lombok.AccessLevel;
import lombok.Builder;
import org.gdsc.globook.domain.entity.Book;

@Builder(access = AccessLevel.PRIVATE)
public record BookDetailResponseDto(
        Long id,
        String title,
        String author,
        String description,
        String imageUrl,
        boolean download,
        boolean favorite,
        List<BookThumbnailResponseDto> otherBookList
) {
    public static BookDetailResponseDto of(
            Book book, Boolean download, Boolean favorite, List<BookThumbnailResponseDto> bookThumbnailResponseDto
    ) {
        return BookDetailResponseDto.builder()
                .id(book.getId())
                .title(book.getTitle())
                .author(book.getAuthor())
                .description(book.getDescription())
                .imageUrl(book.getImageUrl())
                .download(download)
                .favorite(favorite)
                .otherBookList(bookThumbnailResponseDto)
                .build();
    }
}
