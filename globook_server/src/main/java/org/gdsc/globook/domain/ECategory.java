package org.gdsc.globook.domain;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public enum ECategory {
    SCIENCE("과학"),
    HISTORY("역사"),
    ECONOMY("경제"),
    SOCIETY("사회"),
    ART("예술"),
    LANGUAGE("언어"),
    COMPUTER("컴퓨터"),
    SELF_DEVELOPMENT("자기계발"),
    TRAVEL("여행"),
    COOKING("요리"),
    FANTASY("판타지"),
    MYSTERY("미스터리"),
    THRILLER("스릴러"),
    ROMANCE("로맨스");

    private final String category;
}
