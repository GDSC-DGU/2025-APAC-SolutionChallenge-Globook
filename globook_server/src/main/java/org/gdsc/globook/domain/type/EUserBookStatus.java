package org.gdsc.globook.domain.type;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public enum EUserBookStatus {
    DOWNLOAD("다운로드"),
    PROCESSING("다운로드중"),
    READ("읽기");

    private final String status;
}
