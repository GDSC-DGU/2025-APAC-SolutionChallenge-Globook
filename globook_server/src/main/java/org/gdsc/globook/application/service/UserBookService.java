package org.gdsc.globook.application.service;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.BookSummaryResponseDto;
import org.gdsc.globook.application.dto.BookThumbnailResponseDto;
import org.gdsc.globook.application.dto.FavoriteBookListResponseDto;
import org.gdsc.globook.application.dto.FavoriteBookThumbnailResponseDto;
import org.gdsc.globook.application.dto.PdfToMarkdownResponseDto;
import org.gdsc.globook.application.dto.PdfToMarkdownResultDto;
import org.gdsc.globook.application.port.*;
import org.gdsc.globook.application.repository.BookRepository;
import org.gdsc.globook.application.repository.ParagraphRepository;
import org.gdsc.globook.application.repository.UserBookRepository;
import org.gdsc.globook.application.repository.UserRepository;
import org.gdsc.globook.core.exception.CustomException;
import org.gdsc.globook.core.exception.GlobalErrorCode;
import org.gdsc.globook.domain.entity.Book;
import org.gdsc.globook.domain.entity.Paragraph;
import org.gdsc.globook.domain.entity.User;
import org.gdsc.globook.domain.entity.UserBook;
import org.gdsc.globook.domain.type.ELanguage;
import org.gdsc.globook.domain.type.EPersona;
import org.gdsc.globook.domain.type.EUserBookStatus;
import org.gdsc.globook.presentation.request.UserPreferenceRequestDto;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserBookService {
    private final UserBookRepository userBookRepository;
    private final UserRepository userRepository;
    private final BookRepository bookRepository;
    private final PdfFetchService pdfFetchService;
    private final PdfToMarkdownPort pdfToMarkdownPort;
    private final TranslateMarkdownPort translateMarkdownPort;
    private final MarkdownToParagraphPort markdownToParagraphPort;
    private final MarkdownSplitterPort markdownSplitterPort;
    private final ConvertImageToUrlPort convertImageToUrlPort;
    private final ParagraphRepository paragraphRepository;
    private final TTSPort ttsPort;

    public boolean addBookToUserFavorite(Long userId, Long bookId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_BOOK));

        UserBook userBook = getUserBook(user, book)
                .orElseGet(() -> UserBook.create(
                        book, user, false, false, EUserBookStatus.DOWNLOAD
                ));

        userBook.updateFavorite(true);
        userBookRepository.save(userBook);
        return true;
    }

    public boolean deleteBookFromUserFavorite(Long userId, Long bookId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_BOOK));

        UserBook userBook = getUserBook(user, book)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER_BOOK));

        userBook.updateFavorite(false);
        userBookRepository.save(userBook);
        return true;
    }

    @Transactional
    public boolean addBookToUserDownload(Long userId, Long bookId, UserPreferenceRequestDto userPreferenceRequestDto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_BOOK));

        EPersona persona = EPersona.valueOf(userPreferenceRequestDto.persona());
        ELanguage language = ELanguage.valueOf(userPreferenceRequestDto.language());

        UserBook userBook = getUserBook(user, book)
                .orElseGet(() -> UserBook.create(
                        book, user, false, false, EUserBookStatus.PROCESSING
                ));
        userBook.updateStatus(EUserBookStatus.PROCESSING);
        userBook.updatePersona(persona);
        userBook.updateLanguage(language);
        userBookRepository.save(userBook);

        // GCS PDF 다운로드 및 MultipartFile 변환
        MultipartFile bookMultipartFile = getMultipartFileFromBookPdf(book.getOriginUrl());

        // PDF를 마크다운으로 변환
        PdfToMarkdownResponseDto markdownConversionResult = pdfToMarkdownPort.convertPdfToMarkdown(bookMultipartFile);
        PdfToMarkdownResultDto pdfToMarkdownResultDto = PdfToMarkdownResultDto.of(
                markdownConversionResult,
                book.getId()
        );

        // 1. 마크다운 내 이미지 url 처리
        String markdown = convertImageToUrlPort.convertImageToUrl(
                userId,
                userBook.getId(),
                markdownConversionResult.markdown(),
                markdownConversionResult.images()
        );

        // 2. 너무 긴 마크다운 문자열에 대비해서 일정 토큰 정도 단위로 split 후 translate
        List<String> markdownSplitList = markdownSplitterPort.split(markdown);
        List<String> translatedList = new ArrayList<>();
        for (String splitMarkdown : markdownSplitList) {
            String translateMarkdown = translateMarkdownPort.translateMarkdown(
                    userId,
                    userBook.getId(),
                    splitMarkdown,
                    language
            );

            translatedList.add(translateMarkdown);
        }

        // 3. split 후 번역된 translatedList 에서 블록별로 gemini 호출하여 paragraph 생성
        List<String> paragraphTextList = new ArrayList<>();
        for (String chunk : translatedList) {
            // 블록별로 gemini 호출
            paragraphTextList.addAll(markdownToParagraphPort.convertMarkdownToParagraph(chunk));
        }
        log.info("" + paragraphTextList.size());
        userBook.updateMaxIndex((long)paragraphTextList.size());

        // 각각의 paragraph 생성중
        for(int index = 0; index < paragraphTextList.size(); index++) {
            // 마크다운을 문단으로 분리후 paragraph 내에 저장
            String text = paragraphTextList.get(index);
            Paragraph paragraph = Paragraph.createBookParagraph(text, (long) index,"", book);
            paragraphRepository.save(paragraph);

            // 각각의 문단을 일반 문자열로 전환 후 paragraph 업데이트
            String audioUrl = ttsPort.convertTextToSpeech(
                    userId, bookId, paragraph.getId(), paragraph.getContent(), String.valueOf(language), String.valueOf(persona)
            );
            paragraph.updateAudioUrl(audioUrl);
        }

        userBook.updateDownload(true);
        userBook.updateStatus(EUserBookStatus.READ);
        userBookRepository.save(userBook);
        return true;
    }

    public MultipartFile getMultipartFileFromBookPdf(String originUrl) {
        try {
            return pdfFetchService.fetchPdfAsMultipart(originUrl);
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

    public Optional<UserBook> getUserBook(User user, Book book) {
        return userBookRepository.findByUserAndBook(user, book);
    }

    public FavoriteBookListResponseDto getFavoriteBookList(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));

        List<UserBook> userBookList = userBookRepository.findByUserAndFavorite(user, true);
        List<FavoriteBookThumbnailResponseDto> favoriteBookList = userBookList.stream()
                .map(userBook -> FavoriteBookThumbnailResponseDto.fromEntity(
                        userBook.getBook(), userBook
                )).toList();

        return FavoriteBookListResponseDto.fromDtoList(
                favoriteBookList
        );
    }

    @Transactional(readOnly = true)
    public BookSummaryResponseDto getDownloadedBookList(Long userId, Integer size) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));

        List<UserBook> userBookList;
        if (size != null) {
            userBookList = userBookRepository.findByUserAndDownloadIsTrueOrderByCreatedAtDesc(
                    user,
                    PageRequest.of(0, size)
            );
        } else {
            userBookList = userBookRepository.findByUserAndDownloadIsTrueOrderByCreatedAtDesc(user);
        }

        List<BookThumbnailResponseDto> downloadedBookList = userBookList.stream()
                .map(userBook -> BookThumbnailResponseDto.fromEntity(
                        userBook.getBook(), Optional.of(userBook)
                )).toList();

        return BookSummaryResponseDto.of(
                downloadedBookList
        );
    }
}
