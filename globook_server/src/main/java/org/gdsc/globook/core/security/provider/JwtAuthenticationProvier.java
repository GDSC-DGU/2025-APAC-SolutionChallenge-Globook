package org.gdsc.globook.core.security.provider;

import lombok.RequiredArgsConstructor;
import org.gdsc.globook.core.security.info.CustomUserDetails;
import org.gdsc.globook.core.security.info.JwtAuthenticationToken;
import org.gdsc.globook.core.security.info.JwtUserInfo;
import org.gdsc.globook.core.security.service.CustomUserDetailsService;
import org.gdsc.globook.domain.EUserRole;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class JwtAuthenticationProvier implements AuthenticationProvider {
    private final CustomUserDetailsService customUserDetailsService;

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        if (!(authentication instanceof JwtAuthenticationToken jwtAuthenticationToken)) {
            return null;
        }

        Long userId = (Long) jwtAuthenticationToken.getPrincipal();
        EUserRole role = (EUserRole) jwtAuthenticationToken.getCredentials();

        JwtUserInfo jwtUserInfo = JwtUserInfo.builder()
                .id(userId)
                .role(role)
                .build();

        CustomUserDetails userDetails = (CustomUserDetails) customUserDetailsService.loadUserByUserId(jwtUserInfo.id());
        if (userDetails == null) {
            throw new UsernameNotFoundException("User not found for ID: " + jwtUserInfo.id());
        }

        if (!userDetails.getRole().equals(jwtUserInfo.role())) {
            throw new AuthenticationException("Invalid Role") {
            };
        }

        // 인증 성공 시 UsernamePasswordAuthenticationToken에 사용자 정보와 권한 정보를 담아 반환
        return new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());

    }

    @Override
    public boolean supports(Class<?> authentication) {
        return JwtAuthenticationToken.class.isAssignableFrom(authentication);

    }
}
