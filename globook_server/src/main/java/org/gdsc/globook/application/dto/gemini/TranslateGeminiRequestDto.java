package org.gdsc.globook.application.dto.gemini;

import lombok.Builder;

import java.util.List;

@Builder
public record TranslateGeminiRequestDto(
        SystemInstruction systemInstruction,
        List<Content> contents,
        GenerationConfig generationConfig
) {
    private static final Part prompt1
            = new Part("당신은 마크다운을 문자열을 다른 언어로 번역해주는 챗봇입니다. 다른 사족 없이 번역된 문자열만 반환합니다.");
    private static final Part prompt2
            = new Part("""
            You are a Markdown translator. \s
            Your task is to translate only the natural language parts of the given Markdown input. \s
            Follow these rules strictly:

            1. **Do NOT translate or modify any Markdown syntax elements** such as code blocks (```), tables (`| … |`), images (`![]()`), or links (`[text](url)`).
            2. **Do NOT alter the content inside Markdown elements**, including text inside code blocks, list items, tables, etc. Leave them exactly as-is.
            3. **Avoid translating domain-specific proper nouns**, such as technical terms, academic concepts, or product names — unless translation is clearly necessary and improves clarity.
            4. **Preserve the original formatting**, including paragraph structure, line breaks, spacing, and indentation.

            ⚠️ Your output must maintain the original Markdown structure, with only human-readable sentences translated.
            Do not add any extra commentary, metadata, or formatting.
            """);
    private static final List<Part> SYSTEM_PARTS
            = List.of(prompt1, prompt2);
    private static final SystemInstruction DEFAULT_SYSTEM_INSTRUCTION
            = new SystemInstruction(SYSTEM_PARTS);

    public static TranslateGeminiRequestDto from(String markdown) {
        Part inputMessageToGemini = new Part(markdown);
        Content content = new Content(List.of(inputMessageToGemini));

        return TranslateGeminiRequestDto.builder()
                .systemInstruction(DEFAULT_SYSTEM_INSTRUCTION)
                .contents(List.of(content))
                .build();
    }
}