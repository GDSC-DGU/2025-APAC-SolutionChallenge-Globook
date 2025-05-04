package org.gdsc.globook.domain;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "books")
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "author", nullable = false)
    private String author;

    @Column(name = "description", nullable = false)
    private String description;

    @Column(name = "image_url", nullable = false)
    private String imageUrl;    // 표지 이미지 URL

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "category", nullable = false)
    @Enumerated(EnumType.STRING)
    private ECategory category;

    // ------ mapping ------ //
    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserBook> userBooks = new ArrayList<>();

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Paragraph> paragraphs = new ArrayList<>();

    @Builder(access = AccessLevel.PRIVATE)
    public Book(String title, String author, String description, String imageUrl, ECategory category) {
        this.title = title;
        this.author = author;
        this.description = description;
        this.imageUrl = imageUrl;
        this.category = category;
        this.createdAt = LocalDateTime.now();
    }

    public static Book create(String title, String author, String description, String imageUrl, ECategory category) {
        return Book.builder()
                .title(title)
                .author(author)
                .description(description)
                .imageUrl(imageUrl)
                .category(category)
                .build();
    }

}
