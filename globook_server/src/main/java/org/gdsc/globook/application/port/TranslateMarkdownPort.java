package org.gdsc.globook.application.port;

import org.gdsc.globook.application.dto.PdfToMarkdownResponseDto;
import org.gdsc.globook.domain.type.ELanguage;

public interface TranslateMarkdownPort {
    String translateMarkdown(
            Long userId,
            Long fileId,
            PdfToMarkdownResponseDto markdown,
            ELanguage targetLanguage
    );
}
