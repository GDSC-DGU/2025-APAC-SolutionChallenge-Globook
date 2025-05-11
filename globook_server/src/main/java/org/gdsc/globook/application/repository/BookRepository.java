package org.gdsc.globook.application.repository;

import java.util.List;
import org.gdsc.globook.domain.entity.Book;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface BookRepository extends JpaRepository<Book, Long> {

    @Query(value = "SELECT * FROM books b WHERE category = :category AND title != :title LIMIT 3", nativeQuery = true)
    List<Book> findOtherBooksByCategory(@Param("category") String category, @Param("title") String title);

    @Query(value = "SELECT * FROM books b WHERE category = :category", nativeQuery = true)
    List<Book> findAllByCategory(@Param("category") String category);

    @Query(value = "SELECT * FROM books b WHERE title LIKE CONCAT('%', :title, '%')", nativeQuery = true)
    List<Book> searchBooksByTitle(@Param("title") String title);

    @Query(value = "SELECT * FROM books b WHERE category = :category ORDER BY RAND() LIMIT 3", nativeQuery = true)
    List<Book> findRandomBooksLimit3(@Param("category") String category);
}
