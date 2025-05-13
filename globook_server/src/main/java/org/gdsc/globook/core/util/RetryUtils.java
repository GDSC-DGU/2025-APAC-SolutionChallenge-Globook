package org.gdsc.globook.core.util;

public class RetryUtils {

    public interface Retryable<T> {
        T execute() throws Exception;
    }

    public static <T> T retry(
            Retryable<T> task,
            int maxRetries,
            long initialBackoffMillis,
            boolean logFullStacktrace
    ) {
        int attempt = 0;

        while (attempt < maxRetries) {
            try {
                return task.execute();
            } catch (Exception e) {
                attempt++;
                if (attempt >= maxRetries) {
                    if (logFullStacktrace) {
                        throw new RuntimeException("최대 재시도 초과", e);
                    } else {
                        throw new RuntimeException("최대 재시도 초과: " + e.getMessage());
                    }
                }

                long backoff = (long) Math.pow(2, attempt) * initialBackoffMillis;
                System.err.printf("재시도 %d회차 - %s (다음 시도까지 %dms 대기)%n", attempt, e.getMessage(), backoff);
                try {
                    Thread.sleep(backoff);
                } catch (InterruptedException ie) {
                    Thread.currentThread().interrupt();
                    throw new RuntimeException("재시도 중 인터럽트 발생", ie);
                }
            }
        }

        throw new IllegalStateException("이 코드에 도달하면 안됨");
    }
}
