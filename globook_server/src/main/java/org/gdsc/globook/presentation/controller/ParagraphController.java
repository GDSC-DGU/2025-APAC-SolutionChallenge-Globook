package org.gdsc.globook.presentation.controller;

import lombok.RequiredArgsConstructor;
import org.gdsc.globook.application.dto.PdfToMarkdownPollingRequestDto;
import org.gdsc.globook.application.dto.PdfToMarkdownResponseDto;
import org.gdsc.globook.application.dto.UploadPdfRequestDto;
import org.gdsc.globook.application.service.FileService;
import org.gdsc.globook.application.service.ParagraphService;
import org.gdsc.globook.core.annotation.AuthenticationPrincipal;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/users/file")
public class ParagraphController {
    private final FileService fileService;
    private final ParagraphService paragraphService;

    @PostMapping("/all")
    public ResponseEntity<?> createParagraphForFile(
            @AuthenticationPrincipal Long userId,
            @RequestPart(value = "file") MultipartFile file,
            @RequestPart(value = "uploadPdfRequest")UploadPdfRequestDto request
    ) {
        // 1. 입력받은 pdf 기반으로 1차적으로 file 레코드 생성 (status 는 '업로드 중')
        Long fileId = fileService.createFile(userId, file, request);

        // 2. pdf 기반으로 마크다운 문자열 생성 & 정상적으로 생성됐다면 file 레코드 status 뱐걍
        PdfToMarkdownResponseDto markdown = paragraphService.convertMarkdown(file, fileId);

        // 3. 마크다운을 targetLanguage 로 번역 후 Paragraph 레코드 생성
        paragraphService.createParagraphForFile(markdown, userId, fileId, request);

        return ResponseEntity.ok("task done");
    }

    @PostMapping("/upload")
    public ResponseEntity<PdfToMarkdownResponseDto> createParagraphForFileUpload(
            @AuthenticationPrincipal Long userId,
            @RequestPart(value = "file") MultipartFile file,
            @RequestPart(value = "uploadPdfRequest")UploadPdfRequestDto request
    ) {
        // 1. 입력받은 pdf 기반으로 1차적으로 file 레코드 생성 (status 는 '업로드 중')
        Long fileId = fileService.createFile(userId, file, request);

        // 2. pdf 기반으로 마크다운 문자열 생성 & 정상적으로 생성됐다면 file 레코드 status 뱐걍
        PdfToMarkdownResponseDto markdown = paragraphService.convertMarkdown(file, fileId);

        return ResponseEntity.ok().body(markdown);
    }

    @PostMapping("/translate")
    public ResponseEntity<?> createParagraphForFileTranslate(
            @AuthenticationPrincipal Long userId,
            @RequestBody PdfToMarkdownPollingRequestDto request
    ) {
        // 3. 마크다운을 targetLanguage 로 번역 후 Paragraph 레코드 생성

        return ResponseEntity.ok().build();
    }
}
