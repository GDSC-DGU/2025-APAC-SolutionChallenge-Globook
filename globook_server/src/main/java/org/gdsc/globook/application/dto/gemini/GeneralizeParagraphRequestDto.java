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
            = new Part("당신은 마크다운을 문자열을 일반 문자열로 반환하는 챗봇입니다. 다른 사족 없이 일반 문자열만 반환합니다.");
    private static final Part prompt2
            = new Part("""
            입력값은 마크다운 문자열로만 주어집니다.
            다음과 같은 규칙에 따라 마크다운을 일반 문자열로 변환합니다.
            
            1. 일반적인 문자열로 생각되게끔 마크다운 문법은 전부 지우고 일반 문자열을 만들어냅니다.
            2. 마크다운 내 이미지 등 일반 문자열로 바꾸기 어렵다고 생각되는 부분은 그냥 지워버립니다.
            3. 스스로 잘 만들어냈는지 고민해야합니다.
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
