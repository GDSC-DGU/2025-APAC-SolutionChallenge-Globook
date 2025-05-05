package org.gdsc.globook.presentation.request;

public record SignInRequestDto(
        String email,
        String password
) {
}
