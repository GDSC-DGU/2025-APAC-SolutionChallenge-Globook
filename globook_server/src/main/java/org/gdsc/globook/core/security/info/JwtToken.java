package org.gdsc.globook.core.security.info;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;

@Builder
public record JwtToken(
        @NotBlank String accessToken,
        @NotBlank String refreshToken
) {
    public static JwtToken of(String accessToken, String refreshToken) {
        return JwtToken.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }
}

