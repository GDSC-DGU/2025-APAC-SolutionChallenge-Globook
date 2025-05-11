package org.gdsc.globook.application.dto.gemini;


public record GenerationConfig(
        Integer maxOutputTokens,
        String responseMimeType,
        ResponseSchema responseSchema
) {
}