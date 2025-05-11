package org.gdsc.globook.domain.entity;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.gdsc.globook.domain.type.EFileStatus;
import org.gdsc.globook.domain.type.ELanguage;
import org.gdsc.globook.domain.type.EPersona;
import org.hibernate.annotations.DynamicUpdate;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@DynamicUpdate
@Table(name = "files")
public class File {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "`index`", nullable = false)
    private Long index;

    @Column(name = "max_index", nullable = false)
    private Long maxIndex;

    @Column(name = "language", nullable = false)
    @Enumerated(EnumType.STRING)
    private ELanguage language;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "persona", nullable = false)
    @Enumerated(EnumType.STRING)
    private EPersona persona;

    @Column(name = "file_status", nullable = false)
    @Enumerated(EnumType.STRING)
    private EFileStatus fileStatus;

    // ------ Foreign Key ------ //
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "id", nullable = false)
    private User user;  // 사용자(파일 소유자) id

    // ----- mapping ------ //
    @OneToMany(mappedBy = "file", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Paragraph> paragraphs = new ArrayList<>();

    @Builder(access = AccessLevel.PRIVATE)
    public File(String title, User user, EPersona persona, Long maxIndex, ELanguage language) {
        this.title = title;
        this.user = user;
        this.index = 0L;
        this.maxIndex = maxIndex;
        this.language = language;
        this.persona = persona;
        this.createdAt = LocalDateTime.now();
        this.fileStatus = EFileStatus.UPLOAD;
    }

    public static File create(String title, User user, EPersona persona, Long maxIndex, ELanguage language) {
        return File.builder()
                .title(title)
                .user(user)
                .language(language)
                .persona(persona)
                .maxIndex(maxIndex)
                .build();
    }

    public void updateFileStatus() {
        if(this.fileStatus == EFileStatus.UPLOAD) {
            fileStatus = EFileStatus.PROCESSING;
        } else if(this.fileStatus == EFileStatus.PROCESSING) {
            fileStatus = EFileStatus.READ;
        }
    }

    public void updateStatusFail() {

    }

    public void updateMaxIndex(Long maxIndex) {
        this.maxIndex = maxIndex;
    }
}
