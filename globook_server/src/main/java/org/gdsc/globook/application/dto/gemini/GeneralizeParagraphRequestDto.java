package org.gdsc.globook.application.dto.gemini;

import lombok.Builder;

import java.util.List;

@Builder
public record GeneralizeParagraphRequestDto(
        SystemInstruction systemInstruction,
        List<Content> contents,
        GenerationConfig generationConfig
) {
    private static final Part prompt1
            = new Part("You are a chatbot that converts Markdown into plain text. You must return only plain text without any additional comments.");
    private static final Part prompt2
            = new Part("""
        The input will only be provided as a Markdown string.
        Convert the Markdown into plain text following these rules:

        1. Remove all Markdown syntax and convert it into something that reads like a normal sentence.
        2. If any part of the Markdown (e.g., images) is difficult to convert into plain text, simply delete that part.
        3. The output must be in the same language as the input string.
        4. You should self-reflect and ensure the output feels natural and well-converted.
        """);
    private static final List<Part> SYSTEM_PARTS
            = List.of(prompt1, prompt2);
    private static final SystemInstruction DEFAULT_SYSTEM_INSTRUCTION
            = new SystemInstruction(SYSTEM_PARTS);

    public static GeneralizeParagraphRequestDto from(String markdown) {
        Part inputMessageToGemini = new Part(markdown);
        Content content = new Content(List.of(inputMessageToGemini));

        return GeneralizeParagraphRequestDto.builder()
                .systemInstruction(DEFAULT_SYSTEM_INSTRUCTION)
                .contents(List.of(content))
                .build();
    }
}
