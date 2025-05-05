package org.gdsc.globook.application.dto;

import lombok.AccessLevel;
import lombok.Builder;
import org.gdsc.globook.domain.entity.Book;

@Builder(access = AccessLevel.PRIVATE)
public record BookThumbnailResponseDto(
        Long id,
        String title,
        String author,
        String imageUrl,
        String category
) {
    public static BookThumbnailResponseDto fromEntity(Book book) {
        return BookThumbnailResponseDto.builder()
                .id(book.getId())
                .title(book.getTitle())
                .author(book.getAuthor())
                .imageUrl(book.getImageUrl())
                .category(String.valueOf(book.getCategory()))
                .build();
    }
}
