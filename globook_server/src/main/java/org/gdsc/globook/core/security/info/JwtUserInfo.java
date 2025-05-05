package org.gdsc.globook.core.security.info;

import lombok.Builder;
import org.gdsc.globook.domain.type.EUserRole;

@Builder
public record JwtUserInfo(
        Long id, EUserRole role
) {
}
