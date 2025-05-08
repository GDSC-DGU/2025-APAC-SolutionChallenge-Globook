package org.gdsc.globook.presentation.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.BookDetailResponseDto;
import org.gdsc.globook.application.dto.BookListResponseDto;
import org.gdsc.globook.application.dto.BookRandomListResponseDto;
import org.gdsc.globook.application.dto.BookSummaryResponseDto;
import org.gdsc.globook.application.service.BookStoreService;
import org.gdsc.globook.core.annotation.AuthenticationPrincipal;
import org.gdsc.globook.core.common.BaseResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api/v1/books")
public class BookStoreController {
    private final BookStoreService bookStoreService;

    @GetMapping("")
    public BaseResponse<BookListResponseDto> getBookList(
            @AuthenticationPrincipal Long userId,
            @RequestParam(value = "category", required = false) String category
    ) {
        return BaseResponse.success(bookStoreService.getBookList(userId, category));
    }

    @GetMapping("/{bookId}")
    public BaseResponse<BookDetailResponseDto> getBookList(
            @AuthenticationPrincipal Long userId,
            @PathVariable("bookId") Long bookId
    ) {
        return BaseResponse.success(bookStoreService.getBookDetail(userId, bookId));
    }

    @GetMapping("/search")
    public BaseResponse<BookSummaryResponseDto> searchBook(
            @AuthenticationPrincipal Long userId,
            @RequestParam(value = "title") String title
    ) {
        return BaseResponse.success(bookStoreService.searchBook(userId, title));
    }

    @GetMapping("/today")
    public BaseResponse<BookRandomListResponseDto> getTodayBookList(
            @AuthenticationPrincipal Long userId
    ) {
        return BaseResponse.success(bookStoreService.getTodayBookList(userId));
    }
}
