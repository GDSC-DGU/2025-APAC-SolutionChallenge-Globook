package org.gdsc.globook.application.port;

import org.gdsc.globook.application.dto.UploadPdfRequestDto;

public interface TTSPort {
    String convertTextToSpeech(
            Long userId,
            Long fileId,
            Long paragraphId,
            String inputText,
            String targetLanguage,
            String persona
    );
}
