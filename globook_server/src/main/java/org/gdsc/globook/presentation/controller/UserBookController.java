package org.gdsc.globook.presentation.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.StatusResponseDto;
import org.gdsc.globook.application.service.UserBookService;
import org.gdsc.globook.core.annotation.AuthenticationPrincipal;
import org.gdsc.globook.core.common.BaseResponse;
import org.gdsc.globook.presentation.request.UserPreferenceRequestDto;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api/v1/users/books")
public class UserBookController {
    private final UserBookService userBookService;

    // 도서 즐겨찾기 추가
    @PatchMapping("/{bookId}")
    public BaseResponse<Boolean> addBookToUserFavorite(
            @AuthenticationPrincipal Long userId,
            @PathVariable("bookId") Long bookId
    ) {
        return BaseResponse.success(userBookService.addBookToUserFavorite(userId, bookId));
    }

    // 도서 즐겨찾기 삭제
    @DeleteMapping("/{bookId}")
    public BaseResponse<Boolean> deleteBookFromUserFavorite(
            @AuthenticationPrincipal Long userId,
            @PathVariable("bookId") Long bookId
    ) {
        return BaseResponse.success(userBookService.deleteBookFromUserFavorite(userId, bookId));
    }

    // 도서 다운로드
    @PatchMapping("/{bookId}/download")
    public BaseResponse<Boolean> addBookToUserDownload(
            @AuthenticationPrincipal Long userId,
            @PathVariable("bookId") Long bookId,
            @RequestBody UserPreferenceRequestDto userPreferenceRequestDto
            ) {
        return BaseResponse.success(userBookService.addBookToUserDownload(userId, bookId, userPreferenceRequestDto));
    }

}
