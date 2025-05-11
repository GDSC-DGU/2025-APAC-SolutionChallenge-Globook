package org.gdsc.globook.domain.type;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public enum EPersona {
    ETHAN("ETHAN", "MALE", 0.7, 0.7),
    LUNA("LUNA", "FEMALE", 1.3, 1.0),
    KAI("KAI", "MALE", 1.3, 1.3),
    SORA("SORA", "FEMALE", 1.0, 1.3),
    NOAH("NOAH", "MALE", 1.0, 1.0),
    ARIA("ARIA", "FEMALE", 0.7, 0.7);

    private final String persona;
    private final String gender;
    private final Double speakingRate;
    private final Double pitch;
}
