package org.gdsc.globook.application.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.PdfToMarkdownResponseDto;
import org.gdsc.globook.application.dto.UploadPdfRequestDto;
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
    public PdfToMarkdownResponseDto convertMarkdown(
            MultipartFile file,
            Long fileId
    ) {
        // 1. pdf 를 마크다운으로 전환
        PdfToMarkdownResponseDto markdownConversionResult = pdfToMarkdownPort.convertPdfToMarkdown(file);

        // 3. 정상적으로 변경되었다면 file 의 status 변경
        File updateStatusFile = fileRepository.findById(fileId)
                .orElseThrow(() -> CustomException.type(GlobalErrorCode.NOT_FOUND_FILE));
        updateStatusFile.updateFileStatus();

        return markdownConversionResult;
    }

    @Transactional
    public void createParagraphForFile(
            PdfToMarkdownResponseDto markdownConversionResult,
            Long userId,
            Long fileId,
            UploadPdfRequestDto request
    ) {
        // 0. 파일 찾기
        File file = fileRepository.findById(fileId)
                .orElseThrow(() -> CustomException.type(GlobalErrorCode.NOT_FOUND_FILE));

        // 1. 마크다운 내 이미지 url 처리 & 마크다운을 targetLanguage 로 번역
        String markdown = translateMarkdownPort.translateMarkdown(
                userId,
                fileId,
                markdownConversionResult,
                file.getLanguage()
        );

        // 2. 마크다운을 문단으로 분리
        List<String> paragraphTextList =  markdownToParagraphPort.convertMarkdownToParagraph(markdown);

        // 각각의 paragraph 생성중
        for(int index = 0; index < paragraphTextList.size(); index++) {
            // 3. 마크다운을 문단으로 분리후 paragraph 내에 저장
            String text = paragraphTextList.get(index);
            Paragraph paragraph = Paragraph.createFileParagraph(text, (long)index,"", file);
            paragraphRepository.save(paragraph);

            // 4. 각각의 문단을 일반 문자열로 전환 후 paragraph 업데이트
            String audioUrl = ttsPort.convertTextToSpeech(
                    userId, fileId, paragraph.getContent(), paragraph.getId(), request
            );
            paragraph.updateAudioUrl(audioUrl);
            file.updateFileStatus();
        }
    }
}
