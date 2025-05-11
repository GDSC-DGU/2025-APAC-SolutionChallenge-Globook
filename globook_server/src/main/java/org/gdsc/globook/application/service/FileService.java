package org.gdsc.globook.application.service;

import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.dto.PDFListResponseDto;
import org.gdsc.globook.application.dto.PDFSummaryResponseDto;
import org.gdsc.globook.application.dto.UploadPdfRequestDto;
import org.gdsc.globook.application.repository.FileRepository;
import org.gdsc.globook.application.repository.UserRepository;
import org.gdsc.globook.core.exception.CustomException;
import org.gdsc.globook.core.exception.GlobalErrorCode;
import org.gdsc.globook.domain.entity.File;
import org.gdsc.globook.domain.entity.User;
import org.gdsc.globook.domain.type.ELanguage;
import org.gdsc.globook.domain.type.EPersona;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@RequiredArgsConstructor
@Service
public class FileService {
    private final FileRepository fileRepository;
    private final UserRepository userRepository;

    @Transactional
    public Long createFile(
            Long userId,
            MultipartFile file,
            UploadPdfRequestDto request
    ) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));

        // IllegalArgumentException 처리 해줘야됨
        return fileRepository.save(
                File.create(
                        file.getOriginalFilename(),
                        user,
                        EPersona.valueOf(request.persona()),
                        0L,
                        ELanguage.valueOf(request.targetLanguage())
                )
        ).getId();
    }

    @Transactional(readOnly = true)
    public PDFListResponseDto getUploadedFileList(Long userId, Integer size) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));

        List<File> fileList;
        if (size != null) {
            fileList = fileRepository.findByUserOrderByCreatedAtDesc(
                    user,
                    PageRequest.of(0, size)
            );
        } else {
            fileList = fileRepository.findByUserOrderByCreatedAtDesc(user);
        }

        List<PDFSummaryResponseDto> uploadedFiles = fileList.stream()
                .map(PDFSummaryResponseDto::of)
                .toList();

        return PDFListResponseDto.of(uploadedFiles);
    }
}
