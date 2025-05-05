package org.gdsc.globook.core.config;

import java.util.List;
import lombok.RequiredArgsConstructor;
import org.gdsc.globook.core.constant.Constants;
import org.gdsc.globook.core.interceptor.pre.AuthenticationPrincipalArgumentResolver;
import org.gdsc.globook.core.interceptor.pre.AuthenticationPrincipalInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableWebMvc
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer {
    private final AuthenticationPrincipalArgumentResolver httpUserIdArgumentResolver;
    private final AuthenticationPrincipalInterceptor httpUserIdInterceptor;

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        WebMvcConfigurer.super.addArgumentResolvers(resolvers);
        resolvers.add(this.httpUserIdArgumentResolver);
    }

    @Override
    public void addInterceptors(final InterceptorRegistry registry) {
        registry.addInterceptor(this.httpUserIdInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(Constants.NO_NEED_AUTH_URLS);
    }
}
