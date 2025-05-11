package org.gdsc.globook.application.repository;

import org.gdsc.globook.domain.entity.Paragraph;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ParagraphRepository extends JpaRepository<Paragraph, Long> {
}
