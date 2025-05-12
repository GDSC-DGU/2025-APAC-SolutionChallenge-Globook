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
            입력값은 마크다운 문자열로만 주어집니다.
            다음과 같은 규칙에 따라 마크다운을 문자열 배열로 잘라냅니다.
            
            1. 넉넉하게 2문장 크기로 잘라냅니다.
            2. 마크다운 내 표, 리스트 형태 등 정보를 잘랐을 때 이상해질 것 같은 부분은 따로 자르지 않습니다.
            3. 어색하지 않고 자연스럽게 잘라내야 하며, 스스로 잘 만들어냈는지 고민해야합니다.
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

