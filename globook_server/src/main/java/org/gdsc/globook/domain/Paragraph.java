package org.gdsc.globook.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.DynamicUpdate;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@DynamicUpdate
@Table(name = "paragraphs")
public class Paragraph {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "content", nullable = false)
    private String content;

    @Column(name = "`index`", nullable = false)
    private Long index;

    @Column(name = "language", nullable = false)
    private ELanguage language;

    @Column(name = "audio", nullable = false)
    private String audio;

    // ------ Foreign Key ------ //
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "book_id", referencedColumnName = "id")
    private Book book;  // 도서 id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "file_id", referencedColumnName = "id")
    private File file;  // 도서 id

    @Builder(access = AccessLevel.PRIVATE)
    public Paragraph(String content, Long index, ELanguage language, String audio, Book book, File file) {
        this.content = content;
        this.index = index;
        this.language = language;
        this.audio = audio;
        this.book = book;
        this.file = file;
    }

    public static Paragraph createBookParagraph(String content, Long index, ELanguage language, String audio, Book book) {
        return Paragraph.builder()
                .content(content)
                .index(index)
                .language(language)
                .audio(audio)
                .book(book)
                .file(null)
                .build();
    }

    public static Paragraph createFileParagraph(String content, Long index, ELanguage language, String audio, File file) {
        return Paragraph.builder()
                .content(content)
                .index(index)
                .language(language)
                .audio(audio)
                .book(null)
                .file(file)
                .build();
    }
}
