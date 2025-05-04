package org.gdsc.globook.core.constant;

import java.util.List;

public class Constants {
    public static final String BEARER_PREFIX = "Bearer ";
    public static final String AUTHORIZATION_HEADER = "Authorization";
    public static final String ROLE_PREFIX = "ROLE_";
    public static final String USER_ROLE_CLAIM_NAME = "role";
    public static final String USER_ID_CLAIM_NAME = "uid";
    public static final String USER_EMAIL_CLAIM_NAME = "email";
    public static final String CONTENT_TYPE = "Content-Type";

    public static final List<String> NO_NEED_AUTH_URLS = List.of(
            "/health",  // 서버 상태 체크

            "/api/v1/auth/sign-in", // 기본 로그인
            "/api/v1/auth/sign-in/google",   // 구글 로그인

            // 테스트용 API
            "/api/v1/test/sign-up",
            "/api/v1/test/login"
    );
}
