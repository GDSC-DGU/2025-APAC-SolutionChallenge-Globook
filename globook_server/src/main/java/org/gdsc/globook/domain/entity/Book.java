package org.gdsc.globook.domain.entity;

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
import org.gdsc.globook.domain.type.ECategory;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "books")
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "title", nullable = false,  length = 100)
    private String title;

    @Column(name = "author", nullable = false,  length = 100)
    private String author;

    @Column(name = "description", nullable = false, length = 1000)
    private String description;

    @Column(name = "image_url", nullable = false, length = 2048)
    private String imageUrl;    // 표지 이미지 URL

    @Column(name = "origin_url", nullable = false, length = 2048)
    private String originUrl;    // 도서 원본 URL

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "category", nullable = false)
    @Enumerated(EnumType.STRING)
    private ECategory category;

    // ------ mapping ------ //
    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserBook> userBooks = new ArrayList<>();

    @Builder(access = AccessLevel.PRIVATE)
    public Book(String title, String author, String description, String imageUrl, String originUrl, ECategory category) {
        this.title = title;
        this.author = author;
        this.description = description;
        this.imageUrl = imageUrl;
        this.originUrl = originUrl;
        this.category = category;
        this.createdAt = LocalDateTime.now();
    }

    public static Book create(String title, String author, String description, String imageUrl, String originUrl, ECategory category) {
        return Book.builder()
                .title(title)
                .author(author)
                .description(description)
                .imageUrl(imageUrl)
                .originUrl(originUrl)
                .category(category)
                .build();
    }

}
