package org.gdsc.globook.application.service;

import java.util.ArrayList;
import java.util.Objects;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.*;
import org.gdsc.globook.application.port.*;
import org.gdsc.globook.application.repository.FileRepository;
import org.gdsc.globook.application.repository.ParagraphRepository;
import org.gdsc.globook.application.repository.UserBookRepository;
import org.gdsc.globook.core.exception.CustomException;
import org.gdsc.globook.core.exception.GlobalErrorCode;
import org.gdsc.globook.domain.entity.File;
import org.gdsc.globook.domain.entity.Paragraph;
import org.gdsc.globook.domain.entity.UserBook;
import org.gdsc.globook.domain.type.ELanguage;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ParagraphService {
    private final PdfToMarkdownPort pdfToMarkdownPort;
    private final MarkdownSplitterPort markdownSplitterPort;
    private final MarkdownToParagraphPort markdownToParagraphPort;
    private final TranslateMarkdownPort translateMarkdownPort;
    private final ConvertImageToUrlPort convertImageToUrlPort;
    private final TTSPort ttsPort;
    private final FileRepository fileRepository;
    private final ParagraphRepository paragraphRepository;
    private final UserBookRepository userBookRepository;
    @PersistenceContext
    private EntityManager entityManager;

    @Transactional
    public PdfToMarkdownResultDto convertMarkdown(
            MultipartFile file,
            Long fileId
    ) {
        File updateStatusFile = fileRepository.findById(fileId)
                .orElseThrow(() -> CustomException.type(GlobalErrorCode.NOT_FOUND_FILE));

        try {
            // 1. pdf 를 마크다운으로 전환
            PdfToMarkdownResponseDto markdownConversionResult = pdfToMarkdownPort.convertPdfToMarkdown(file);

            // 2. 정상적으로 변경되었다면 file 의 status 변경
            updateStatusFile.updateFileStatus();

            return PdfToMarkdownResultDto.of(markdownConversionResult, updateStatusFile.getId());
        } catch (Exception e) {
            // 정상적으로 변경되지 않은 경우 file 의 status fail 로 변경
            updateStatusFile.updateStatusFail();

            throw e;
        }
    }

    @Transactional
    public void createParagraphForFile(
            PdfToMarkdownResultDto markdownConversionResult,
            Long userId,
            String targetLanguage,
            String persona
    ) {
        // 0. 파일 찾기
        Long fileId = markdownConversionResult.fileId();
        File file = fileRepository.findById(fileId)
                .orElseThrow(() -> CustomException.type(GlobalErrorCode.NOT_FOUND_FILE));

        try {
            // 1. 마크다운 내 이미지 url 처리
            String markdown = convertImageToUrlPort.convertImageToUrl(
                    userId,
                    fileId,
                    markdownConversionResult.markdown(),
                    markdownConversionResult.images()
            );

            // 2. 너무 긴 마크다운 문자열에 대비해서 일정 토큰 정도 단위로 split
            List<String> markdownSplitList = markdownSplitterPort.split(markdown);

            // Executor 한 번만 생성해서 재사용
            ExecutorService executor = Executors.newFixedThreadPool(10); // 전체 병렬 처리용

            // 3. 분할된 마크다운에 대해 번역 (병렬 처리)
            List<CompletableFuture<String>> futuresTranslate = markdownSplitList.stream()
                    .map(splitMarkdown -> CompletableFuture.supplyAsync(() ->
                            translateMarkdownPort.translateMarkdown(
                                    userId,
                                    fileId,
                                    splitMarkdown,
                                    ELanguage.valueOf(targetLanguage)
                            ), executor)
                    )
                    .toList();

            List<String> translatedList = futuresTranslate.stream()
                    .map(CompletableFuture::join)
                    .toList();

            log.info("\n\n\n\n\n\n\n\n\n");
            for (String s : translatedList) {
                log.info(s);
            }

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

            log.info("paragraph 총 개수: {}", paragraphTextList.size());
            file.updateMaxIndex((long)paragraphTextList.size());

            // 5. 각 paragraph 저장
            int batchSize = 100;
            for (int i = 0; i < paragraphTextList.size(); i++) {
                String text = paragraphTextList.get(i);
                Paragraph paragraph = Paragraph.createFileParagraph(text, (long) i, "", file);
                entityManager.persist(paragraph);

                if (i % batchSize == 0 && i > 0) {
                    entityManager.flush();
                    entityManager.clear();
                }
            }
            entityManager.flush();
            entityManager.clear();

            // 6. TTS 적용 및 update
            List<Paragraph> paragraphList = paragraphRepository.findAllByFileId(file.getId());

            List<CompletableFuture<Void>> futuresTTS = paragraphList.stream()
                    .map(paragraph -> CompletableFuture.runAsync(() -> {
                        String audioUrl = ttsPort.convertTextToSpeech(
                                userId,
                                fileId,
                                paragraph.getId(),
                                paragraph.getContent(),
                                targetLanguage,
                                persona
                        );
                        paragraph.updateAudioUrl(audioUrl);
                    }, executor))
                    .toList();

            futuresTTS.forEach(CompletableFuture::join);

            // 모든 작업 후 스레드 풀 종료
            executor.shutdown();

            // 정상적으로 변경되었다면 file 의 status 변경
            File updateStatusFile = fileRepository.findById(fileId)
                            .orElseThrow(() -> CustomException.type(GlobalErrorCode.NOT_FOUND_FILE));

            updateStatusFile.updateFileStatus();
        } catch (Exception e) {
            // 정상적으로 변경되지 않은 경우 file 의 status fail 로 변경
            file.updateStatusFail();

            throw e;
        }
    }

    @Transactional(readOnly = true)
    public ParagraphListResponseDto getParagraphsByIndex(String type, Long fileId, Long index, String direction) {
        long start, end;
        switch (direction) {
            case "UP" -> {
                start = Math.max(0, index - 25);
                end = index - 1;
            }
            case "DOWN" -> {
                start = index + 1;
                end = index + 25;
            }
            case "FIRST" -> {
                start = Math.max(0, index - 25);
                end = index + 25;
            }
            default -> throw new CustomException(GlobalErrorCode.INVALID_DIRECTION);
        }

        File file = null;
        UserBook userBook = null;
        if (type.equals("FILE")) {
            file = fileRepository.findById(fileId)
                    .orElseThrow(() -> CustomException.type(GlobalErrorCode.NOT_FOUND_FILE));
        }
        else if (type.equals("BOOK")) {
            userBook = userBookRepository.findById(fileId)
                    .orElseThrow(() -> CustomException.type(GlobalErrorCode.NOT_FOUND_BOOK));
        } else {
            throw new CustomException(GlobalErrorCode.INVALID_REQUEST_TYPE);
        }

        List<Paragraph> paragraphList;

        // type 에 따라 bookId 또는 fileId로 조회
        if (type.equals("FILE")) {
            paragraphList = paragraphRepository.findAroundIndexByFileId(fileId, start, end);
        } else if (type.equals("BOOK")) {
            paragraphList = paragraphRepository.findAroundIndexByBookId(fileId, start, end);
        } else {
            throw new CustomException(GlobalErrorCode.INVALID_REQUEST_TYPE);
        }

        List<ParagraphResponseDto> paragraphResponseList = paragraphList.stream().map(
                paragraph -> ParagraphResponseDto.builder()
                        .index(paragraph.getIndex())
                        .text(paragraph.getContent())
                        .voiceFile(paragraph.getAudioUrl())
                        .build()
        ).toList();

        ParagraphInfoResponseDto paragraphsInfo = ParagraphInfoResponseDto.of(
                file != null ? file.getId() : userBook.getId(),
                file != null ? file.getMaxIndex() : Objects.requireNonNull(userBook).getMaxIndex(),
                file != null ? file.getTitle() : userBook.getBook().getTitle(),
                file != null ? "FILE" : "BOOK",
                file != null ? null : userBook.getBook().getImageUrl(),
                file != null ? file.getLanguage() : userBook.getLanguage(),
                file != null ? file.getPersona() : userBook.getPersona()
        );

        return ParagraphListResponseDto.builder()
                .paragraphList(paragraphResponseList)
                .paragraphsInfo(paragraphsInfo)
                .build();
    }
}
