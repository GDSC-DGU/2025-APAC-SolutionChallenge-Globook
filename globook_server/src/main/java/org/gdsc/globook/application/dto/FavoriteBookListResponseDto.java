package org.gdsc.globook.application.dto;

import java.util.List;
import lombok.AccessLevel;
import lombok.Builder;

@Builder(access = AccessLevel.PRIVATE)
public record FavoriteBookListResponseDto(
        List<FavoriteBookThumbnailResponseDto> favoriteBooks
) {
    public static FavoriteBookListResponseDto fromDtoList(List<FavoriteBookThumbnailResponseDto> favoriteBooks) {
        return FavoriteBookListResponseDto.builder()
                .favoriteBooks(favoriteBooks)
                .build();
    }
}
