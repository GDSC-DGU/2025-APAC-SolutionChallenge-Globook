package org.gdsc.globook.application.dto;

import java.util.List;
import lombok.AccessLevel;
import lombok.Builder;
import org.gdsc.globook.domain.entity.Book;
import org.gdsc.globook.domain.type.EUserBookStatus;

@Builder(access = AccessLevel.PRIVATE)
public record BookDetailResponseDto(
        Long id,
        Long userBookId,
        String title,
        String author,
        String description,
        String imageUrl,
        String download,
        boolean favorite,
        List<BookThumbnailResponseDto> otherBookList
) {
    public static BookDetailResponseDto of(
            Book book, Long userBookId, String download, Boolean favorite, List<BookThumbnailResponseDto> bookThumbnailResponseDto
    ) {
        return BookDetailResponseDto.builder()
                .id(book.getId())
                .userBookId(userBookId)
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
