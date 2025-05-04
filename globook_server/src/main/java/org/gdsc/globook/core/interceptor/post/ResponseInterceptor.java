package org.gdsc.globook.core.interceptor.post;

import lombok.NonNull;
import org.gdsc.globook.core.common.BaseResponse;
import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

@RestControllerAdvice
public class ResponseInterceptor implements ResponseBodyAdvice<Object> {
    @Override
    public boolean supports(
            MethodParameter returnType,
            @NonNull Class converterType
    ) {
        return (returnType.getParameterType() != BaseResponse.class)
                && MappingJackson2HttpMessageConverter.class.isAssignableFrom(converterType);
    }

    @Override
    public @NonNull Object beforeBodyWrite(
            @NonNull Object body,
            @NonNull MethodParameter returnType,
            @NonNull MediaType selectedContentType,
            @NonNull Class selectedConverterType,
            @NonNull ServerHttpRequest request,
            @NonNull ServerHttpResponse response
    ) {
        if(body instanceof BaseResponse<?> baseResponse)
            if (Boolean.FALSE.equals(baseResponse.success())) {
                return body;
            }
        return BaseResponse.success(body);
    }
}
