package org.gdsc.globook.application.dto;

import java.util.Map;

public record MarkdownConversionResult(
        String markdown,
        Map<String, String> images
) {
}
