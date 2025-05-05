package org.gdsc.globook.application.service;

import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.repository.BookRepository;
import org.gdsc.globook.application.repository.UserBookRepository;
import org.gdsc.globook.application.repository.UserRepository;
import org.gdsc.globook.core.exception.CustomException;
import org.gdsc.globook.core.exception.GlobalErrorCode;
import org.gdsc.globook.domain.entity.Book;
import org.gdsc.globook.domain.entity.User;
import org.gdsc.globook.domain.entity.UserBook;
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
                .orElseGet(() -> UserBook.create(book, user, false, false));

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

    public boolean addBookToUserDownload(Long userId, Long bookId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_BOOK));

        UserBook userBook = getUserBook(user, book)
                .orElseGet(() -> UserBook.create(book, user, false, false));

        userBook.updateDownload(true);
        userBookRepository.save(userBook);
        return true;
    }

    public Optional<UserBook> getUserBook(User user, Book book) {
        return userBookRepository.findByUserAndBook(user, book);
    }
}
