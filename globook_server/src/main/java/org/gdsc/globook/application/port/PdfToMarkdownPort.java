package org.gdsc.globook.application.port;

import org.gdsc.globook.application.dto.PdfToMarkdownResponseDto;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface PdfToMarkdownPort {
    PdfToMarkdownResponseDto convertPdfToMarkdown(
            MultipartFile file
    );
}
