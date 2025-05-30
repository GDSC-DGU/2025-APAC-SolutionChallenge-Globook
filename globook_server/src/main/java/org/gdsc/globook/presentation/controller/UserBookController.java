package org.gdsc.globook.presentation.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.BookSummaryResponseDto;
import org.gdsc.globook.application.dto.FavoriteBookListResponseDto;
import org.gdsc.globook.application.dto.PdfToMarkdownResultDto;
import org.gdsc.globook.application.service.UserBookService;
import org.gdsc.globook.core.annotation.AuthenticationPrincipal;
import org.gdsc.globook.core.common.BaseResponse;
import org.gdsc.globook.presentation.request.UserPreferenceRequestDto;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api/v1/users/books")
public class UserBookController {
    private final UserBookService userBookService;

    // 다운로드한 도서 리스트 가져오기 - 보관함
    @GetMapping("")
    public BaseResponse<BookSummaryResponseDto> getDownloadedBookList(
            @AuthenticationPrincipal Long userId,
            @RequestParam(value = "size", required = false) Integer size
    ) {
        return BaseResponse.success(userBookService.getDownloadedBookList(userId, size));
    }

    // 도서 즐겨찾기 추가
    @GetMapping("/favorites")
    public BaseResponse<FavoriteBookListResponseDto> getFavoriteBookList(
            @AuthenticationPrincipal Long userId
    ) {
        return BaseResponse.success(userBookService.getFavoriteBookList(userId));
    }

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
        userBookService.updateUserBookStatus(userId, bookId, userPreferenceRequestDto);

        return BaseResponse.success(userBookService.addBookToUserDownload(userId, bookId, userPreferenceRequestDto));
    }

    @DeleteMapping("/userBook/{userBookId}")
    public BaseResponse<?> deleteUserBook(
            @PathVariable("userBookId") Long userBookId
    ) {
        userBookService.deleteUserBook(userBookId);

        return BaseResponse.success(null);
    }
}
