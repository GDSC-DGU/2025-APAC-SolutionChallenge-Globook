package org.gdsc.globook.application.dto;

import lombok.Builder;
import org.gdsc.globook.domain.type.ELanguage;
import org.gdsc.globook.domain.type.EPersona;

@Builder
public record TTSRequestDto(
        Input input,
        Voice voice,
        AudioConfig audioConfig
) {
    public static TTSRequestDto from(String inputString, ELanguage language, EPersona persona){
        return TTSRequestDto.builder()
                .input(new Input(inputString))
                .voice(new Voice(language.getLanguageCode(), persona.getGender()))
                .audioConfig(new AudioConfig("MP3", persona.getSpeakingRate(), persona.getPitch())).build();
    }
}

record Input(
        String text
) {
}

record Voice(
        String languageCode,
        String ssmlGender
) {
}

record AudioConfig(
        String audioEncoding,
        Double speakingRate,
        Double pitch
) {
}
