package org.gdsc.globook.application.port;

import java.util.List;

public interface MarkdownToParagraphPort {
    List<String> convertMarkdownToParagraph(String markdown);
}
