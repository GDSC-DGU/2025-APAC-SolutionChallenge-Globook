package org.gdsc.globook.application.dto;

public record PdfToMarkdownResponsePollingDto(
        Boolean success,
        String error,
        String request_check_url
) {
}
