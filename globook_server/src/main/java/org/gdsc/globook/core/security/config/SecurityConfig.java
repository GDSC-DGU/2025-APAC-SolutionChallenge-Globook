package org.gdsc.globook.core.security.config;

import java.util.Arrays;
import lombok.RequiredArgsConstructor;
import org.gdsc.globook.core.constant.Constants;
import org.gdsc.globook.core.security.filter.JwtAuthenticationFilter;
import org.gdsc.globook.core.security.filter.JwtExceptionFilter;
import org.gdsc.globook.core.security.handler.JwtAccessDeniedHandler;
import org.gdsc.globook.core.security.handler.JwtAuthEntryPoint;
import org.gdsc.globook.core.security.manager.CustomAuthenticationManager;
import org.gdsc.globook.core.security.provider.JwtAuthenticationProvier;
import org.gdsc.globook.core.security.provider.UsernamePasswordAuthenticationProvider;
import org.gdsc.globook.core.util.JwtUtil;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.logout.LogoutFilter;

@Configuration
@RequiredArgsConstructor
@EnableWebSecurity
@EnableMethodSecurity(securedEnabled = true)
public class SecurityConfig {
    private final JwtUtil jwtUtil;
    private final JwtAuthenticationProvier jwtAuthenticationProvider;
    private final UsernamePasswordAuthenticationProvider usernamePasswordAuthenticationProvider;
    private final JwtAuthEntryPoint jwtAuthEntryPoint;
    private final JwtAccessDeniedHandler jwtAccessDeniedHandler;

    @Bean
    public AuthenticationManager authenticationManager() {
        return new CustomAuthenticationManager(Arrays.asList(
                usernamePasswordAuthenticationProvider,
                jwtAuthenticationProvider
        ));
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(sessionManagement ->
                        sessionManagement.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                .authorizeHttpRequests(authorizeRequests ->
                        authorizeRequests
                                .requestMatchers(Constants.NO_NEED_AUTH_URLS.toArray(new String[0])).permitAll()
                                .anyRequest().authenticated()
                )
                .formLogin(AbstractHttpConfigurer::disable)
                .exceptionHandling((exceptionHandling) ->
                        exceptionHandling
                                .authenticationEntryPoint(jwtAuthEntryPoint)
                                .accessDeniedHandler(jwtAccessDeniedHandler)
                )
                .addFilterBefore(new JwtAuthenticationFilter(jwtUtil, authenticationManager()), LogoutFilter.class)
                .addFilterAfter(new JwtExceptionFilter(), JwtAuthenticationFilter.class)
                .build();
    }
}
