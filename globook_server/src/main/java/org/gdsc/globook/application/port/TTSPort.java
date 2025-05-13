package org.gdsc.globook.application.port;

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
