package org.gdsc.globook.application.repository;

import org.gdsc.globook.domain.entity.Paragraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ParagraphRepository extends JpaRepository<Paragraph, Long> {
    @Query("""
    SELECT p FROM Paragraph p
    WHERE p.file.id = :fileId
    AND p.index BETWEEN :start AND :end
    ORDER BY p.index ASC
    """)
    List<Paragraph> findAroundIndexByFileId(
            @Param("fileId") Long fileId,
            @Param("start") Long start,
            @Param("end") Long end
    );

    @Query("""
    SELECT p FROM Paragraph p
    WHERE p.book.id = :bookId
    AND p.index BETWEEN :start AND :end
    ORDER BY p.index ASC
    """)
    List<Paragraph> findAroundIndexByBookId(
            @Param("bookId") Long bookId,
            @Param("start") Long start,
            @Param("end") Long end
    );

}
