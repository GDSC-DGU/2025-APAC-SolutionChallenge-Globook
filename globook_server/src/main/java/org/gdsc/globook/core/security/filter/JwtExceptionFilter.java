package org.gdsc.globook.core.security.filter;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.core.exception.ErrorCode;
import org.gdsc.globook.core.exception.GlobalErrorCode;
import org.springframework.web.filter.OncePerRequestFilter;

@Slf4j
public class JwtExceptionFilter extends OncePerRequestFilter {
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        try {
            // 다음 필터 호출
            filterChain.doFilter(request, response);
        } catch (Exception e) {
            log.error("Exception caught in JwtExceptionFilter: {}", e.getMessage(), e);
            // 예외 유형에 따라 에러 코드를 결정
            ErrorCode errorCode = determineErrorCode(e);
            // 에러 응답 작성 후 필터 체인 중단
            handleException(response, errorCode);
        }
    }

    private ErrorCode determineErrorCode(Exception e) {
        if (e instanceof SecurityException) {
            return GlobalErrorCode.ACCESS_DENIED_ERROR;
        } else {
            return GlobalErrorCode.NOT_FOUND_USER;
        }
    }

    private void handleException(HttpServletResponse response, ErrorCode errorCode) throws IOException {
        response.setStatus(errorCode.getStatus().value());
        response.setContentType("application/json;charset=UTF-8");

        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("data", null);
        result.put("message", errorCode.getMessage());

        String jsonResponse = objectMapper.writeValueAsString(result);
        response.getWriter().write(jsonResponse);
    }
}
