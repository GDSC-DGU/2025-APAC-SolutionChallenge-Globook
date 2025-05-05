package org.gdsc.globook.application.response;

import lombok.AccessLevel;
import lombok.Builder;

@Builder(access = AccessLevel.PRIVATE)
public record OAuth2UserInfo(
        String oAuthId,    // 구글 sub
        String email
) {
    public static OAuth2UserInfo of(String oAuthId, String email) {
        return OAuth2UserInfo.builder()
                .oAuthId(oAuthId)
                .email(email)
                .build();
    }
}
