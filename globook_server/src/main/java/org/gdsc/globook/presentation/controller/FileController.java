package org.gdsc.globook.presentation.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.PDFListResponseDto;
import org.gdsc.globook.application.service.FileService;
import org.gdsc.globook.core.annotation.AuthenticationPrincipal;
import org.gdsc.globook.core.common.BaseResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api/v1/users/files")
public class FileController {
    private final FileService fileService;

    // 업로드한 PDF 리스트 가져오기 - 보관함
    @GetMapping("")
    public BaseResponse<PDFListResponseDto> getUploadedFileList(
            @AuthenticationPrincipal Long userId,
            @RequestParam(value = "size", required = false) Integer size
    ) {
        return BaseResponse.success(fileService.getUploadedFileList(userId, size));
    }
}
