package org.gdsc.globook.application.service;

import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.StatusResponseDto;
import org.gdsc.globook.application.repository.BookRepository;
import org.gdsc.globook.application.repository.UserBookRepository;
import org.gdsc.globook.application.repository.UserRepository;
import org.gdsc.globook.core.exception.CustomException;
import org.gdsc.globook.core.exception.GlobalErrorCode;
import org.gdsc.globook.domain.entity.Book;
import org.gdsc.globook.domain.entity.User;
import org.gdsc.globook.domain.entity.UserBook;
import org.gdsc.globook.domain.type.ELanguage;
import org.gdsc.globook.domain.type.EPersona;
import org.gdsc.globook.domain.type.EUserBookStatus;
import org.gdsc.globook.presentation.request.UserPreferenceRequestDto;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserBookService {
    private final UserBookRepository userBookRepository;
    private final UserRepository userRepository;
    private final BookRepository bookRepository;

    public boolean addBookToUserFavorite(Long userId, Long bookId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_BOOK));

        UserBook userBook = getUserBook(user, book)
                .orElseGet(() -> UserBook.create(
                        book, user, false, false, EUserBookStatus.DOWNLOAD
                ));

        userBook.updateFavorite(true);
        userBookRepository.save(userBook);
        return true;
    }

    public boolean deleteBookFromUserFavorite(Long userId, Long bookId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_BOOK));

        UserBook userBook = getUserBook(user, book)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER_BOOK));

        userBook.updateFavorite(false);
        userBookRepository.save(userBook);
        return true;
    }

    public boolean addBookToUserDownload(Long userId, Long bookId, UserPreferenceRequestDto userPreferenceRequestDto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_BOOK));

        EPersona persona = EPersona.valueOf(userPreferenceRequestDto.persona());
        ELanguage language = ELanguage.valueOf(userPreferenceRequestDto.language());

        UserBook userBook = getUserBook(user, book)
                .orElseGet(() -> UserBook.create(
                        book, user, false, false, EUserBookStatus.PROCESSING
                ));

        userBook.updatePersona(persona);
        userBook.updateLanguage(language);
        // userBook.updateMaxIndex(book.getMaxIndex()); <- 이거는 나중에 다운로드할 때 해줘야함
        userBook.updateDownload(true);
        userBookRepository.save(userBook);
        return true;
    }

    public Optional<UserBook> getUserBook(User user, Book book) {
        return userBookRepository.findByUserAndBook(user, book);
    }
}
