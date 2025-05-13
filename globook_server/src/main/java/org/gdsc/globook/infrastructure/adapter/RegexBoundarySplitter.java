package org.gdsc.globook.infrastructure.adapter;

import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.port.MarkdownSplitterPort;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Slf4j
@Component
public class RegexBoundarySplitter implements MarkdownSplitterPort {
    private static final int TOKEN_BUDGET = 6000;
    // 분할 지점에 대한 정규표현식
    private static final Pattern SAFE = Pattern.compile(
            "(?m)^\\s*$|^#{1,6}\\s|^[-*+]\\s|^```"
    );

    @Override
    public List<String> split(String md) {
        List<String> chunks = new ArrayList<>();
        int start = 0;

        int i = 0;
        // 전체 문자열을 TOKEN_BUDGET 을 기준으로 반복적으로 분할
        while (start < md.length()) {
            log.info("문단 분리 횟수 : " + i);

            // 현재 위치에서 대략적인 종료 지점을 계산
            int approxEnd = approxIdx(md, start);

            // 검색 구간을 start ~ approxEnd 로 한정
            Matcher m = SAFE.matcher(md).region(start, approxEnd);

            int cut = -1;
            while (m.find()) {
                cut = m.end();
            }

            // 안전한 지점이 없거나 너무 가까우면 강제로 자름
            if (cut == -1 || cut <= start) {
                cut = approxEnd;
            }

            // 잘라낸 부분을 결과 리스트에 추가
            chunks.add(md.substring(start, cut));
            start = cut;
            i++;
        }

        System.out.println("전체 리스트 사이즈 조회 " + chunks.size());
        return chunks;
    }

    // 주어진 시작 위치 기준으로 TOKEN_BUDGET 에 해당하는 문자 수만큼의 종료 위치를 근사 계산
    private int approxIdx(String md, int off) {
        return Math.min(md.length(), (int) (off + TOKEN_BUDGET * 4.2));
    }
}
