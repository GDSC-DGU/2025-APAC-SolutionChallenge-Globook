package org.gdsc.globook.presentation.request;

public record SignUpRequestDto(
        String email,
        String password,
        String passwordConfirm
) {
}
