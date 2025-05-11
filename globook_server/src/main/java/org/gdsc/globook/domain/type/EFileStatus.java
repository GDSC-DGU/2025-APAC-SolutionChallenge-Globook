package org.gdsc.globook.domain.type;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public enum EFileStatus {
    UPLOAD("업로드중"),
    PROCESSING("번역중"),
    READ("읽기"),
    FAIL("실패");

    private final String status;
}
