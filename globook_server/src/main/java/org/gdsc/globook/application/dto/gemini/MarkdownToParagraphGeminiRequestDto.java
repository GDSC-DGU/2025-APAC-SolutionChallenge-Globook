package org.gdsc.globook.application.dto.gemini;

import lombok.Builder;

import java.util.List;

@Builder
public record MarkdownToParagraphGeminiRequestDto(
        SystemInstruction systemInstruction,
        List<Content> contents,
        GenerationConfig generationConfig
) {
    private static final Part prompt1
            = new Part("당신은 마크다운을 문자열 배열로 잘라 반환하는 챗봇입니다. 다른 사족 없이 잘라진 배열로만 반환합니다.");
    private static final Part prompt2
            = new Part("""
            The input is a single pure Markdown string.
            Split the string into an array of segments according to the following rules:
                        
            Each segment should contain approximately 2 complete sentences. (Minimum 1, maximum 3 sentences allowed.)
                        
            Do not break inside Markdown structures like tables, lists, code blocks, or headings. If a structure may break, include the entire block as-is.
                        
            When splitting, ensure the break points feel natural, especially in mixed Korean-English text. Use sentence-ending punctuation (e.g., ., ?, !) as cues.
                        
            Preserve all line breaks and spacing exactly as in the original input.
                        
            After splitting, review your output and adjust any awkward or incorrect segments to make the result smooth and natural.
                        
            ⚠️ Output format: a pure JSON array of strings (e.g., ["chunk1", "chunk2", …]).
            Do not include any extra explanation, comments, or metadata.
            """);
    private static final List<Part> SYSTEM_PARTS
            = List.of(prompt1, prompt2);
    private static final SystemInstruction DEFAULT_SYSTEM_INSTRUCTION
            = new SystemInstruction(SYSTEM_PARTS);
    private static final ResponseSchema RESPONSE_SCHEMA
            = new ResponseSchema("ARRAY", new Item("STRING"));
    private static final GenerationConfig GENERATION_CONFIG
            = new GenerationConfig(16384,"application/json", RESPONSE_SCHEMA);

    public static MarkdownToParagraphGeminiRequestDto from(String markdown) {
        Part inputMessageToGemini = new Part(markdown);
        Content content = new Content(List.of(inputMessageToGemini));

        return MarkdownToParagraphGeminiRequestDto.builder()
                .systemInstruction(DEFAULT_SYSTEM_INSTRUCTION)
                .contents(List.of(content))
                .generationConfig(GENERATION_CONFIG)
                .build();
    }
}

