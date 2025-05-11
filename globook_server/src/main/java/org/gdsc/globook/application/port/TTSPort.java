package org.gdsc.globook.application.port;

import org.gdsc.globook.application.dto.UploadPdfRequestDto;

public interface TTSPort {
    String convertTextToSpeech(
            Long userId,
            Long fileId,
            String inputText,
            Long paragraphId,
            UploadPdfRequestDto request
    );
}
