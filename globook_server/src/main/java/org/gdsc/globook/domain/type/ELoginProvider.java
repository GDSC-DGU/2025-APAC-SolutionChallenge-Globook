package org.gdsc.globook.domain.type;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public enum ELoginProvider {
    GOOGLE("GOOGLE"),
    DEFAULT("DEFAULT");

    private final String loginProvider;
}
