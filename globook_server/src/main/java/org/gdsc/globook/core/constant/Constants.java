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
    public static final String APPLICATION_FORM_URLENCODED_WITH_CHARSET = "application/x-www-form-urlencoded;charset=utf-8";
    public static final String GOOGLE_RESOURCE_SERVER_URL = "https://www.googleapis.com/oauth2/v3/userinfo";
    public static final String GOOGLE_SOCIAL_ID_FIELD = "sub";
    public static final String AUTHENTICATION = "authentication";

    public static final List<String> NO_NEED_AUTH_URLS = List.of(
            "/health",  // 서버 상태 체크

            "/api/v1/auth/sign-in", // 기본 로그인
            "/api/v1/auth/sign-in/google",   // 구글 로그인
            "/api/v1/auth/sign-up", // 회원가입

            // 테스트용 API
            "/api/v1/test/sign-up",
            "/api/v1/test/login"
    );
}
