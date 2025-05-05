package org.gdsc.globook.application.repository;

import java.util.List;
import java.util.Optional;
import org.gdsc.globook.domain.entity.Book;
import org.gdsc.globook.domain.entity.User;
import org.gdsc.globook.domain.entity.UserBook;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserBookRepository extends JpaRepository<UserBook, Long> {
    Optional<UserBook> findByUserAndBook(User user, Book book);


    List<UserBook> findByUserAndFavorite(User user, Boolean favorite);

    List<UserBook> findByUserAndDownload(User user, Boolean download);
}
