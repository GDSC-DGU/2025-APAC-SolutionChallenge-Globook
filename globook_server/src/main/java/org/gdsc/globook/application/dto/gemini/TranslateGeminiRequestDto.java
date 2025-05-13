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
            = new Part("You are a chatbot that translates markdown strings into other languages. Returns only strings that have been translated without any family.");
    private static final Part prompt2
            = new Part("The characters to be translated are given as 'TRANSLATE TO Languages to be translated' at the beginning of the string. The string will not be included in the translation.");
    private static final Part prompt3
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
            = List.of(prompt1, prompt2, prompt3);
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