package org.gdsc.globook.core.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.http.HttpServletRequest;
import java.security.Key;
import java.util.Date;
import org.gdsc.globook.core.constant.Constants;
import org.gdsc.globook.core.security.info.JwtToken;
import org.gdsc.globook.domain.EUserRole;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Component
public class JwtUtil implements InitializingBean {
    @Value("${jwt.secret}")
    private String secretKey;

    @Value("${jwt.access-token-validity-in-milli-seconds}")
    private Long accessTokenExpirationPeriod;

    @Value("${jwt.refresh-token-validity-in-milli-seconds}")
    private Long refreshTokenExpirationPeriod;

    private Key key;

    @Override
    public void afterPropertiesSet() throws Exception {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        this.key = Keys.hmacShaKeyFor(keyBytes);
    }

    public String createToken(String email, EUserRole role, Long expirationPeriod) {
        Claims claims = Jwts.claims();
        claims.put(Constants.USER_EMAIL_CLAIM_NAME, email);
        claims.put(Constants.USER_ROLE_CLAIM_NAME, role.toString());

        Date now = new Date();
        Date tokenValidity = new Date(now.getTime() + expirationPeriod);

        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(now)
                .setExpiration(tokenValidity)
                .signWith(key, SignatureAlgorithm.HS512)
                .compact();
    }

    public String createToken(Long id, EUserRole role, Long expirationPeriod) {
        Claims claims = Jwts.claims();
        claims.put(Constants.USER_ID_CLAIM_NAME, id);
        claims.put(Constants.USER_ROLE_CLAIM_NAME, role.toString());

        Date now = new Date();
        Date tokenValidity = new Date(now.getTime() + expirationPeriod);    // 토큰의 만료시간 설정

        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(now)
                .setExpiration(tokenValidity)
                .signWith(key, SignatureAlgorithm.HS512)
                .compact();
    }

    public JwtToken generateToken(Long id, EUserRole role) {
        return JwtToken.of(createToken(id, role, accessTokenExpirationPeriod),
                createToken(id, role, refreshTokenExpirationPeriod));
    }

    public Claims validateAndGetClaimsFromToken(String token) throws JwtException {
        final JwtParser jwtParser = Jwts.parserBuilder().setSigningKey(key).build();
        return jwtParser.parseClaimsJws(token).getBody();
    }

    public String getJwtFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader(Constants.AUTHORIZATION_HEADER);
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith(Constants.BEARER_PREFIX)) {
            return bearerToken.substring(Constants.BEARER_PREFIX.length());
        }
        return null;
    }

    public Long getUserIdFromToken(String token) {
        Claims claims = validateAndGetClaimsFromToken(token);
        return claims.get(Constants.USER_ID_CLAIM_NAME, Long.class);
    }
}
