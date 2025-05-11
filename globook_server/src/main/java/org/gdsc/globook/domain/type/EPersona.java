package org.gdsc.globook.domain.type;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public enum EPersona {
    ETHAN("ETHAN", "MALE", 1.0, 1.0),
    LUNA("LUNA", "FEMALE", 1.0, 1.0),
    KAI("KAI", "MALE", 1.0, 1.0),
    SORA("SORA", "FEMALE", 1.0, 1.0),
    NOAH("NOAH", "MALE", 1.0, 1.0),
    ARIA("ARIA", "FEMALE", 1.0, 1.0);

    private final String persona;
    private final String gender;
    private final Double speakingRate;
    private final Double pitch;
}
