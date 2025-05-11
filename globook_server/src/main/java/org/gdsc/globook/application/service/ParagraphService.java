package org.gdsc.globook.application.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.*;
import org.gdsc.globook.application.port.MarkdownToParagraphPort;
import org.gdsc.globook.application.port.PdfToMarkdownPort;
import org.gdsc.globook.application.port.TTSPort;
import org.gdsc.globook.application.port.TranslateMarkdownPort;
import org.gdsc.globook.application.repository.FileRepository;
import org.gdsc.globook.application.repository.ParagraphRepository;
import org.gdsc.globook.core.exception.CustomException;
import org.gdsc.globook.core.exception.GlobalErrorCode;
import org.gdsc.globook.domain.entity.File;
import org.gdsc.globook.domain.entity.Paragraph;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ParagraphService {
    private final PdfToMarkdownPort pdfToMarkdownPort;
    private final MarkdownToParagraphPort markdownToParagraphPort;
    private final TranslateMarkdownPort translateMarkdownPort;
    private final TTSPort ttsPort;
    private final FileRepository fileRepository;
    private final ParagraphRepository paragraphRepository;

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
            // 1. 마크다운 내 이미지 url 처리 & 마크다운을 targetLanguage 로 번역
            String markdown = translateMarkdownPort.translateMarkdown(
                    userId,
                    fileId,
                    markdownConversionResult,
                    file.getLanguage()
            );

            // 2. 마크다운을 문단으로 분리
            List<String> paragraphTextList =  markdownToParagraphPort.convertMarkdownToParagraph(markdown);
            file.updateMaxIndex((long)paragraphTextList.size());

            // 각각의 paragraph 생성중
            for(int index = 0; index < paragraphTextList.size(); index++) {
                // 3. 마크다운을 문단으로 분리후 paragraph 내에 저장
                String text = paragraphTextList.get(index);
                Paragraph paragraph = Paragraph.createFileParagraph(text, (long)index,"", file);
                paragraphRepository.save(paragraph);

                // 4. 각각의 문단을 일반 문자열로 전환 후 paragraph 업데이트
                String audioUrl = ttsPort.convertTextToSpeech(
                        userId, fileId, paragraph.getId(), paragraph.getContent(), targetLanguage, persona
                );
                paragraph.updateAudioUrl(audioUrl);
            }
            // 정상적으로 변경되었다면 file 의 status 변경
            file.updateFileStatus();
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

        return new ParagraphListResponseDto(paragraphResponseList);
    }
}
