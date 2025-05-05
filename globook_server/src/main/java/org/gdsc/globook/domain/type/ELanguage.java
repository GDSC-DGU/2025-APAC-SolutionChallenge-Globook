package org.gdsc.globook.domain.type;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public enum ELanguage {
    KO("KOREAN"),
    EN("ENGLISH"),
    JA("JAPANESE"),
    ZH("CHINESE"),
    ES("SPANISH"),
    FR("FRENCH"),
    DE("GERMAN"),
    IT("ITALIAN"),
    PT("PORTUGUESE"),
    RU("RUSSIAN");

    private final String language;
}
