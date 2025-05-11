package org.gdsc.globook.domain.type;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public enum ELanguage {
    KO("KOREAN", "ko"),
    EN("ENGLISH", "en"),
    JA("JAPANESE", "ja"),
    ZH("CHINESE", "zh"),
    ES("SPANISH", "es"),
    FR("FRENCH", "fr"),
    DE("GERMAN", "de"),
    IT("ITALIAN", "it"),
    PT("PORTUGUESE", "pt"),
    RU("RUSSIAN", "ru");

    private final String language;
    private final String languageCode;
}
