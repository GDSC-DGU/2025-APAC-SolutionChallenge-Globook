package org.gdsc.globook.core.exception;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public enum GlobalErrorCode implements ErrorCode{
    /**
     * 400 : 요청 실패
     */
    VALIDATION_ERROR(HttpStatus.BAD_REQUEST, "잘못된 요청입니다."),
    BAD_JSON(HttpStatus.BAD_REQUEST, "요청 형식이 잘못되었거나 JSON 구조가 유효하지 않습니다."),
    CONSTRAINT_VIOLATION(HttpStatus.CONFLICT, "데이터베이스 제약 조건에 위배되었습니다."),
    MISSING_REQUEST_HEADER(HttpStatus.BAD_REQUEST, "필수 요청 헤더가 누락되었습니다."),
    TYPE_MISMATCH(HttpStatus.BAD_REQUEST, "요청 값의 타입이 올바르지 않습니다."),
    OAUTH2_USER_INFO_REQUEST_FAILED(HttpStatus.BAD_REQUEST, "OAuth2 사용자 정보 요청에 실패했습니다."),
    INValid(HttpStatus.BAD_REQUEST, "잘못된 요청 헤더입니다."),
    ALREADY_EXISTS(HttpStatus.BAD_REQUEST, "이미 존재하는 데이터입니다."),
    NOT_FOUND_USER_BOOK(HttpStatus.BAD_REQUEST, "존재하지 않는 사용자 도서입니다."),
    INVALID_REQUEST_TYPE(HttpStatus.BAD_REQUEST, "잘못된 요청 타입입니다."),

    /**
     * 401 : 인증 실패
     */
    ACCESS_DENIED_ERROR(HttpStatus.UNAUTHORIZED, "인증되지 않은 사용자입니다."),
    INVALID_TOKEN_ERROR(HttpStatus.UNAUTHORIZED, "유효하지 않은 토큰입니다."),
    EMPTY_AUTHENTICATION(HttpStatus.UNAUTHORIZED, "인증 정보가 없습니다."),

    /**
     * 403 : 권한 부족
     */
    INVALID_HEADER_VALUE(HttpStatus.FORBIDDEN, "접근 권한이 없습니다."),

    /**
     * 404 : 리소스 없음
     */
    NOT_FOUND_USER(HttpStatus.NOT_FOUND, "존재하지 않는 사용자입니다."),
    NOT_SUPPORTED_URI_ERROR(HttpStatus.NOT_FOUND, "지원하지 않는 URL 입니다."),
    NOT_FOUND(HttpStatus.NOT_FOUND, "존재하지 않는 데이터입니다."),
    NOT_FOUND_BOOK(HttpStatus.NOT_FOUND, "존재하지 않는 도서입니다."),
    NOT_FOUND_FILE(HttpStatus.NOT_FOUND, "존재하지 않는 파일입니다."),

    /**
     * 405 : 지원하지 않는 HTTP Method
     */
    NOT_SUPPORTED_METHOD_ERROR(HttpStatus.METHOD_NOT_ALLOWED, "지원하지 않는 HTTP Method 요청입니다."),

    /**
     * 500 : 응답 실패
     */
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "서버와의 연결에 실패했습니다."),
    ;

    private final HttpStatus status;
    private final String message;
}

