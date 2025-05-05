package org.gdsc.globook.presentation.request;

public record UserPreferenceRequestDto(
        String language,
        String persona
) {
}
