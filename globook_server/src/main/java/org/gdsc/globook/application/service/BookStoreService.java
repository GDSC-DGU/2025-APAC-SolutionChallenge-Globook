package org.gdsc.globook.application.service;

import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.BookDetailResponseDto;
import org.gdsc.globook.application.dto.BookListResponseDto;
import org.gdsc.globook.application.dto.BookRandomListResponseDto;
import org.gdsc.globook.application.dto.BookSummaryResponseDto;
import org.gdsc.globook.application.dto.BookThumbnailResponseDto;
import org.gdsc.globook.application.repository.BookRepository;
import org.gdsc.globook.application.repository.UserRepository;
import org.gdsc.globook.core.exception.CustomException;
import org.gdsc.globook.core.exception.GlobalErrorCode;
import org.gdsc.globook.domain.entity.Book;
import org.gdsc.globook.domain.entity.User;
import org.gdsc.globook.domain.entity.UserBook;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class BookStoreService {
    private final BookRepository bookRepository;
    private final UserBookService userBookService;
    private final UserRepository userRepository;

    // 서점 - 도서 카테고리별 리스트 조회
    public BookListResponseDto getBookList(Long userId, String category) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));

        List<Book> bookList;
        List<BookThumbnailResponseDto> bookThumbnailResponseDtoList;
        if (category == null || category.isEmpty()) {
            bookList = bookRepository.findAll();
        } else {
            bookList = bookRepository.findAllByCategory(category);
        }
        bookThumbnailResponseDtoList = bookList
                .stream()
                .map(BookThumbnailResponseDto::fromEntity)
                .toList();

        return BookListResponseDto.of(bookThumbnailResponseDtoList);
    }

    // 서점 - 도서 상세 조회
    public BookDetailResponseDto getBookDetail(Long userId, Long bookId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_BOOK));

        Optional<UserBook> userBook = userBookService.getUserBook(user, book);

        boolean download = false;
        boolean favorite = false;
        if (userBook.isPresent()) {
            download = userBook.get().getDownload();
            favorite = userBook.get().getFavorite();
        }

        List<Book> bookList = bookRepository.findOtherBooksByCategory(String.valueOf(book.getCategory()), book.getTitle());
        List<BookThumbnailResponseDto> bookThumbnailResponseDtoList = bookList
                .stream()
                .map(BookThumbnailResponseDto::fromEntity)
                .toList();

        return BookDetailResponseDto.of(
                book,
                download,
                favorite,
                bookThumbnailResponseDtoList
        );
    }

    public BookSummaryResponseDto searchBook(Long userId, String title) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));

        List<Book> bookList = bookRepository.searchBooksByTitle(title);
        List<BookThumbnailResponseDto> bookThumbnailResponseDtoList = bookList
                .stream()
                .map(BookThumbnailResponseDto::fromEntity)
                .toList();

        return BookSummaryResponseDto.of(bookThumbnailResponseDtoList);
    }

    // 서점 - 오늘의 책 조회
    public BookRandomListResponseDto getTodayBookList(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));
        List<Book> todayBookList = bookRepository.findRandomBooksLimit3();

        List<BookThumbnailResponseDto> bookThumbnailResponseDtoList = todayBookList.stream()
                .map(BookThumbnailResponseDto::fromEntity)
                .toList();

        return BookRandomListResponseDto.of(bookThumbnailResponseDtoList);
    }

}
