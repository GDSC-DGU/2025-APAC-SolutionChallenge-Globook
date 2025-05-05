package org.gdsc.globook.domain.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.DynamicUpdate;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@DynamicUpdate
@Table(name = "user_books")
public class UserBook {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "download", columnDefinition = "TINYINT(1)", nullable = false)
    private Boolean download; // 다운로드 여부

    @Column(name = "favorite", columnDefinition = "TINYINT(1)", nullable = false)
    private Boolean favorite; // 즐겨찾기 여부

    @Column(name = "`index`", nullable = false)
    private Long index;

    // ------ Foreign Key ------ //
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "book_id", referencedColumnName = "id")
    private Book book;  // 도서 id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private User user;  // 유저 id

    @Builder(access = AccessLevel.PRIVATE)
    public UserBook(Book book, User user, Boolean download, Boolean favorite) {
        this.book = book;
        this.user = user;
        this.createdAt = LocalDateTime.now();
        this.download = download;
        this.favorite = favorite;
        this.index = 0L;
    }

    public static UserBook create(Book book, User user, Boolean download, Boolean favorite) {
        return UserBook.builder()
                .download(download)
                .favorite(favorite)
                .book(book)
                .user(user)
                .build();
    }

    public void updateDownload(Boolean download) {
        this.download = download;
    }

    public void updateFavorite(Boolean favorite) {
        this.favorite = favorite;
    }
}
