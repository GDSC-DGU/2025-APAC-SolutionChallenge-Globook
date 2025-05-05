package org.gdsc.globook.domain.type;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public enum ECategory {
    SCIENCE("SCIENCE"),
    HISTORY("HISTORY"),
    ECONOMY("ECONOMY"),
    SOCIETY("SOCIETY"),
    COMPUTER("COMPUTER"),
    SELF_DEVELOPMENT("SELF_DEVELOPMENT"),
    FANTASY("FANTASY"),
    MYSTERY("MYSTERY"),
    THRILLER("THRILLER"),
    ROMANCE("ROMANCE");

    private final String category;
}
