package org.gdsc.globook.domain.type;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public enum EUserBookStatus {
    DOWNLOAD("download"),
    PROCESSING("downloading"),
    READ("read");

    private final String status;
}
