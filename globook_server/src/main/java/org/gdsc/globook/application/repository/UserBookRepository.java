package org.gdsc.globook.application.repository;

import java.util.List;
import java.util.Optional;
import org.antlr.v4.runtime.atn.SemanticContext.AND;
import org.gdsc.globook.domain.entity.Book;
import org.gdsc.globook.domain.entity.User;
import org.gdsc.globook.domain.entity.UserBook;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserBookRepository extends JpaRepository<UserBook, Long> {
    Optional<UserBook> findByUserAndBook(User user, Book book);

    List<UserBook> findByUserAndFavorite(User user, Boolean favorite);

    // 전체 조회 (다운로드 true)
    List<UserBook> findByUserAndDownloadIsTrueOrderByCreatedAtDesc(User user);

    // 제한된 개수 조회
    List<UserBook> findByUserAndDownloadIsTrueOrderByCreatedAtDesc(User user, Pageable pageable);
}
