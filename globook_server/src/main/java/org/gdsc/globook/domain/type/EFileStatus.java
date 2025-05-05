package org.gdsc.globook.domain.type;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public enum EFileStatus {
    UPLOAD("업로드중"),
    PROCESSING("번역중"),
    DONE("완료");

    private final String status;
}
