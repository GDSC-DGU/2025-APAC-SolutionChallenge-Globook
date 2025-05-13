package org.gdsc.globook.application.port;

import org.gdsc.globook.application.dto.PdfToMarkdownResultDto;
import org.gdsc.globook.domain.type.ELanguage;

public interface TranslateMarkdownPort {
    String translateMarkdown(
            Long userId,
            Long fileId,
            String markdown,
            ELanguage targetLanguage
    );
}
