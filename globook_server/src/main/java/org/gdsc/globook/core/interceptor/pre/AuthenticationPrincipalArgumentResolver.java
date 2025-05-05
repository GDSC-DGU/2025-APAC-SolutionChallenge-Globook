package org.gdsc.globook.core.interceptor.pre;

import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.core.annotation.AuthenticationPrincipal;
import org.gdsc.globook.core.constant.Constants;
import org.gdsc.globook.core.exception.CustomException;
import org.gdsc.globook.core.exception.GlobalErrorCode;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

@Component
@Slf4j
public class AuthenticationPrincipalArgumentResolver implements HandlerMethodArgumentResolver {
    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        log.info("supportsParameter = {}", parameter.getParameterType().equals(Long.class) &&
                parameter.hasParameterAnnotation(AuthenticationPrincipal.class));
        return parameter.getParameterType().equals(Long.class) && parameter.hasParameterAnnotation(AuthenticationPrincipal.class);
    }

    @Override
    public Object resolveArgument(MethodParameter parameter,
                                  ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest,
                                  WebDataBinderFactory binderFactory) throws Exception {
        final Object userIdObj = webRequest.getAttribute(Constants.AUTHENTICATION, NativeWebRequest.SCOPE_REQUEST);

        log.info("resolveArgument = {}", userIdObj);
        if (userIdObj == null) {
            throw new CustomException(GlobalErrorCode.ACCESS_DENIED_ERROR);
        }
        return Long.valueOf(userIdObj.toString());
    }
}
