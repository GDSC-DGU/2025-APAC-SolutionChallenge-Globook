package org.gdsc.globook.application.dto;

import lombok.AccessLevel;
import lombok.Builder;
import org.gdsc.globook.domain.entity.Book;
import org.gdsc.globook.domain.entity.UserBook;

@Builder(access = AccessLevel.PRIVATE)
public record FavoriteBookThumbnailResponseDto(
        Long id,
        String title,
        String author,
        String imageUrl,
        String download
) {
    public static FavoriteBookThumbnailResponseDto fromEntity(Book book, UserBook userBook) {
        return FavoriteBookThumbnailResponseDto.builder()
                .id(book.getId())
                .imageUrl(book.getImageUrl())
                .title(book.getTitle())
                .author(book.getAuthor())
                .download(userBook.getStatus().getStatus())
                .build();
    }
}
