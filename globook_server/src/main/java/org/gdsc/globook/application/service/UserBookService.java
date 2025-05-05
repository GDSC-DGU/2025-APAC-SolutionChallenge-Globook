package org.gdsc.globook.application.service;

import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.repository.UserBookRepository;
import org.gdsc.globook.core.exception.CustomException;
import org.gdsc.globook.domain.entity.Book;
import org.gdsc.globook.domain.entity.User;
import org.gdsc.globook.domain.entity.UserBook;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserBookService {
    private final UserBookRepository userBookRepository;

    public void addBookToUserFavorite(User user, Book book) {
        UserBook userBook = UserBook.create(book, user, false, true);
        userBookRepository.save(userBook);
    }

    public void addBookToUserDownload(User user, Book book) {
        UserBook userBook = UserBook.create(book, user, true, false);
        userBookRepository.save(userBook);
    }

    public Optional<UserBook> getUserBook(User user, Book book) {
        return userBookRepository.findByUserAndBook(user, book);
    }
}
