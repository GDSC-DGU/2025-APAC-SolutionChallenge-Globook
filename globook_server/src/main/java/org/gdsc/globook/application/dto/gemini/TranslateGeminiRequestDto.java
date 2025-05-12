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
            입력값은 마크다운 문자열로만 주어집니다.
            다음과 같은 규칙에 따라 입력된 마크다운 문자열을 번역합니다.
            
            1. 마크다운 문법 요소(예: 코드 블럭, 표, 이미지, 링크)는 절대로 번역하지 말 것.
            2. 마크다운 문법 요소 내부에 포함된 텍스트도 변형하지 말 것. (예: 코드 블럭 안의 코드 등.)
            3. 완전히 학술적인 용어의 고유명사라고 생각되는 경우 번역을 지양할 것. (필요에 의해서는 해도 됩니다.)
            4. 단락 간의 구조, 줄바꿈 등 원본의 형식을 최대한 보존할 것.
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