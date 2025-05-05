package org.gdsc.globook.core.interceptor.pre;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.core.constant.Constants;
import org.gdsc.globook.core.exception.CustomException;
import org.gdsc.globook.core.exception.GlobalErrorCode;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
@Slf4j
public class AuthenticationPrincipalInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        log.info("authentication = {}", authentication);
        if (authentication == null) {
            throw new CustomException(GlobalErrorCode.EMPTY_AUTHENTICATION);
        }
        request.setAttribute(Constants.AUTHENTICATION, authentication.getName());
        log.info("AUTHENTICATION_PRINCIPAL = {}", authentication.getName());
        return HandlerInterceptor.super.preHandle(request, response, handler);
    }

}
