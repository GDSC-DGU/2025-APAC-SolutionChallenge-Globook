package org.gdsc.globook.presentation.controller;

import lombok.RequiredArgsConstructor;
import org.gdsc.globook.application.dto.ParagraphListResponseDto;
import org.gdsc.globook.application.dto.PdfToMarkdownResultDto;
import org.gdsc.globook.application.service.FileService;
import org.gdsc.globook.application.service.ParagraphService;
import org.gdsc.globook.core.annotation.AuthenticationPrincipal;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/users")
public class ParagraphController {
    private final FileService fileService;
    private final ParagraphService paragraphService;

    @PostMapping("/files/upload")
    public ResponseEntity<PdfToMarkdownResultDto> createParagraphForFileUpload(
            @AuthenticationPrincipal Long userId,
            @RequestPart(value = "file") MultipartFile file,
            @RequestParam String targetLanguage,
            @RequestParam String persona
    ) {
        // 1. 입력받은 pdf 기반으로 1차적으로 file 레코드 생성 (status 는 '업로드 중')
        Long fileId = fileService.createFile(userId, file, targetLanguage, persona);

        // 2. pdf 기반으로 마크다운 문자열 생성 & 정상적으로 생성됐다면 file 레코드 status 뱐걍
        PdfToMarkdownResultDto markdown = paragraphService.convertMarkdown(file, fileId);

        return ResponseEntity.ok().body(markdown);
    }

    @PostMapping("/files/translate")
    public ResponseEntity<?> createParagraphForFileTranslate(
            @AuthenticationPrincipal Long userId,
            @RequestBody PdfToMarkdownResultDto request,
            @RequestParam String targetLanguage,
            @RequestParam String persona
    ) {
        // 3. 마크다운을 targetLanguage 로 번역 후 Paragraph 레코드 생성
        paragraphService.createParagraphForFile(request, userId, targetLanguage, persona);

        return ResponseEntity.ok().build();
    }

    @GetMapping("/paragraphs")
    public ResponseEntity<ParagraphListResponseDto> getParagraphsByIndex(
            @AuthenticationPrincipal Long userId,
            @RequestParam String type,
            @RequestParam Long fileId,
            @RequestParam Long index,
            @RequestParam String direction
    ) {
        switch (type) {
            case "FILE" -> {
                fileService.updateFileIndex(fileId, index);
            }
            case "BOOK" -> {
                // 유저 북 테이블에 대해 index 업데이트
            }
        }

        return ResponseEntity.ok(paragraphService.getParagraphsByIndex(type, fileId, index, direction));
    }
}
