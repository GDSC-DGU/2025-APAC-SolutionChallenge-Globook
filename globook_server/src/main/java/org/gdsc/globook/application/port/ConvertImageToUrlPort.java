package org.gdsc.globook.application.port;

import java.util.Map;

public interface ConvertImageToUrlPort {
    String convertImageToUrl(
            Long userId,
            Long fileId,
            String markdown,
            Map<String, String> images
    );
}
