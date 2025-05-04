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
    NOT_FOUND(HttpStatus.NOT_FOUND, "잘못된 접근입니다."),
    NOT_SUPPORTED_URI_ERROR(HttpStatus.NOT_FOUND, "지원하지 않는 URL 입니다."),
    NOT_SUPPORTED_METHOD_ERROR(HttpStatus.METHOD_NOT_ALLOWED, "지원하지 않는 HTTP Method 요청입니다."),
    INVALID_HEADER_VALUE(HttpStatus.UNAUTHORIZED, "올바르지 않은 헤더값입니다."),
    BAD_JSON(HttpStatus.BAD_REQUEST, "요청 형식이 잘못되었거나 JSON 구조가 유효하지 않습니다."),
    CONSTRAINT_VIOLATION(HttpStatus.CONFLICT, "데이터베이스 제약 조건에 위배되었습니다."),
    MISSING_REQUEST_HEADER(HttpStatus.BAD_REQUEST, "필수 요청 헤더가 누락되었습니다."),
    TYPE_MISMATCH(HttpStatus.BAD_REQUEST, "요청 값의 타입이 올바르지 않습니다."),

    /**
     * 500 : 응답 실패
     */
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "서버와의 연결에 실패했습니다."),
    ;

    private final HttpStatus status;
    private final String message;
}

