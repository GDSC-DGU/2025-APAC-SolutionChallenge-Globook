package org.gdsc.globook.application.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.*;
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

import java.net.URISyntaxException;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

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
    public void updateUserBookStatus(Long userId, Long bookId, UserPreferenceRequestDto userPreferenceRequestDto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_BOOK));

        UserBook userBook = getUserBook(user, book)
                .orElseGet(() -> UserBook.create(
                        book, user, false, false, EUserBookStatus.PROCESSING
                ));

        userBook.updateStatus(EUserBookStatus.PROCESSING);
        userBook.updatePersona(EPersona.valueOf(userPreferenceRequestDto.persona()));
        userBook.updateLanguage(ELanguage.valueOf(userPreferenceRequestDto.language()));
        userBookRepository.save(userBook);
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
                .orElseThrow(() -> new RuntimeException("updateUserBookStatus 에서 생성했음"));

        // GCS PDF 다운로드 및 MultipartFile 변환
        MultipartFile bookMultipartFile = getMultipartFileFromBookPdf(book.getOriginUrl());

        try {
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
                    pdfToMarkdownResultDto.markdown(),
                    pdfToMarkdownResultDto.images()
            );

            // 2. 너무 긴 마크다운 문자열에 대비해서 일정 토큰 정도 단위로 split
            List<String> markdownSplitList = markdownSplitterPort.split(markdown);

            // Executor 한 번만 생성해서 재사용
            ExecutorService executor = Executors.newFixedThreadPool(50); // 전체 병렬 처리용

            // 3. 분할된 마크다운에 대해 번역 (병렬 처리)
            List<CompletableFuture<String>> futuresTranslate = markdownSplitList.stream()
                    .map(splitMarkdown -> CompletableFuture.supplyAsync(() ->
                            translateMarkdownPort.translateMarkdown(
                                    userId,
                                    userBook.getId(),
                                    splitMarkdown,
                                    language
                            ), executor)
                    )
                    .toList();

            List<String> translatedList = futuresTranslate.stream()
                    .map(CompletableFuture::join)
                    .toList();

            // 4. 번역된 각 블록에 대해 paragraph 추출 (병렬 처리)
            List<CompletableFuture<List<String>>> futuresParagraph = translatedList.stream()
                    .map(chunk -> CompletableFuture.supplyAsync(() ->
                            markdownToParagraphPort.convertMarkdownToParagraph(chunk), executor)
                    )
                    .toList();

            // List<List<String>> → List<String> 평탄화
            List<String> paragraphTextList = futuresParagraph.stream()
                    .map(CompletableFuture::join)
                    .flatMap(List::stream)
                    .toList();
            userBook.updateMaxIndex((long)paragraphTextList.size());

            // 5. 각 paragraph 저장
            for (int i = 0; i < paragraphTextList.size(); i++) {
                String text = paragraphTextList.get(i);
                Paragraph paragraph = Paragraph.createBookParagraph(text, (long) i, "", userBook);
                paragraphRepository.save(paragraph);
            }

            // 6. TTS 적용 및 update
            List<Paragraph> paragraphList = paragraphRepository.findAllByBookId(userBook.getId());

            List<CompletableFuture<Void>> futuresTTS = paragraphList.stream()
                    .map(paragraph -> CompletableFuture.runAsync(() -> {
                        String audioUrl = ttsPort.convertTextToSpeech(
                                userId,
                                bookId,
                                paragraph.getId(),
                                paragraph.getContent(),
                                userPreferenceRequestDto.language(),
                                userPreferenceRequestDto.persona()
                        );
                        paragraph.updateAudioUrl(audioUrl);
                    }, executor))
                    .toList();

            futuresTTS.forEach(CompletableFuture::join);

            // 모든 작업 후 스레드 풀 종료
            executor.shutdown();

            // 작업이 정상적으로 완료되었다면 userBook status 알맞게 변경
            userBook.updateDownload(true);
            userBook.updateStatus(EUserBookStatus.READ);
            userBookRepository.save(userBook);
            return true;
        } catch (Exception e) {
            // 작업이 정상적으로 완료되었다면 userBook status 다시 변경
            userBook.updateStatus(EUserBookStatus.DOWNLOAD);

            throw new RuntimeException("정상 다운로드 실패");
        }
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

    @Transactional
    public void deleteUserBook(Long userBookId) {
        UserBook userBook = userBookRepository.findById(userBookId).orElseThrow();

        userBookRepository.delete(userBook);
    }
}
