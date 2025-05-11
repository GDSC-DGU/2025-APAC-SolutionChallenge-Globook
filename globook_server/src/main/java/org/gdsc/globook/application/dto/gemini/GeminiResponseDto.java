package org.gdsc.globook.application.dto.gemini;

import java.util.List;

public record GeminiResponseDto(
        List<Candidate> candidates
) {
}

