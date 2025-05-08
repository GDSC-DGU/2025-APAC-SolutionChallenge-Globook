package org.gdsc.globook.application.repository;

import java.util.List;
import org.gdsc.globook.domain.entity.File;
import org.gdsc.globook.domain.entity.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FileRepository extends JpaRepository<File, Long> {
    List<File> findByUserOrderByCreatedAtDesc(User user);
    List<File> findByUserOrderByCreatedAtDesc(User user, Pageable pageable);
}
