package org.gdsc.globook.core.security.filter;

import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.core.constant.Constants;
import org.gdsc.globook.core.security.info.JwtAuthenticationToken;
import org.gdsc.globook.core.security.info.JwtUserInfo;
import org.gdsc.globook.core.util.JwtUtil;
import org.gdsc.globook.domain.type.EUserRole;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

@RequiredArgsConstructor
@Slf4j
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    private final JwtUtil jwtUtil;
    private final AuthenticationManager authenticationManager;

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        return Constants.NO_NEED_AUTH_URLS.stream().anyMatch(request.getRequestURI()::startsWith);
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        log.info("JWT Authentication Filter");


        final String token = jwtUtil.getJwtFromRequest(request);
        if (StringUtils.hasText(token)) {
            try {
                Claims claims = jwtUtil.validateAndGetClaimsFromToken(token);

                JwtUserInfo jwtUserInfo = JwtUserInfo.builder()
                        .id(claims.get(Constants.USER_ID_CLAIM_NAME, Long.class))
                        .role(EUserRole.valueOf(claims.get(Constants.USER_ROLE_CLAIM_NAME, String.class)))
                        .build();

                // JWT 정보로 커스텀 JwtAuthenticationToken 생성
                JwtAuthenticationToken beforeAuthentication =
                        new JwtAuthenticationToken(null, jwtUserInfo.id(), jwtUserInfo.role());

                // AuthenticationManager에 위임
                Authentication authenticationResult = authenticationManager.authenticate(beforeAuthentication);

                SecurityContextHolder.getContext().setAuthentication(authenticationResult);
                log.info("JWT Authentication Success: {}", authenticationResult.getName());
            } catch (Exception ex) {
                SecurityContextHolder.clearContext();
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, ex.getMessage());
                return;
            }
        }

        filterChain.doFilter(request, response);
    }

}
