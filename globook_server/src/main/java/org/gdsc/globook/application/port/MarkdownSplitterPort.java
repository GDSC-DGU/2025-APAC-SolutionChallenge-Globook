package org.gdsc.globook.application.port;

import java.util.List;

public interface MarkdownSplitterPort {
    List<String> split(String markdown);
}
