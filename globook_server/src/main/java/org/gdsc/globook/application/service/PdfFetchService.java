package org.gdsc.globook.application.service;

import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Paths;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.mock.web.MockMultipartFile;

@Service
public class PdfFetchService {
    private final Storage storage;

    public PdfFetchService() {
        // 기본 자격증명(GCP JSON 키파일 설정)으로 Storage 클라이언트 초기화
        this.storage = StorageOptions.getDefaultInstance().getService();
    }

    /**
     * GCS URL에서 PDF를 내려받아 MultipartFile로 변환
     * @param gcsUrl https://storage.googleapis.com/globook-bucket/books/{bookId}/bookname.pdf
     */
    public MultipartFile fetchPdfAsMultipart(String gcsUrl) throws URISyntaxException {
        URI uri = new URI(gcsUrl);

        // 1) URL 경로 분해
        //    path 예시: "/globook-bucket/books/123/mybook.pdf"
        String path = uri.getPath();            // "/globook-bucket/books/123/mybook.pdf"
        String[] parts = path.split("/", 4);    // ["", "globook-bucket", "books", "123/mybook.pdf"]

        if (parts.length < 4 || !"books".equals(parts[2])) {
            throw new IllegalArgumentException("지원하지 않는 GCS URL 형식입니다: " + gcsUrl);
        }

        String bucket = parts[1];                // "globook-bucket"
        String objectPath = parts[2] + "/" + parts[3]; // "books/123/mybook.pdf"

        // 2) Blob 읽기
        Blob blob = storage.get(BlobId.of(bucket, objectPath));
        if (blob == null || !blob.exists()) {
            throw new IllegalArgumentException("GCS에 해당 파일이 존재하지 않습니다: " + gcsUrl);
        }
        byte[] content = blob.getContent();

        // 3) 파일명·타입
        String filename = Paths.get(objectPath).getFileName().toString(); // "mybook.pdf"
        String contentType = blob.getContentType() != null
                ? blob.getContentType()
                : "application/pdf";

        // 4) MultipartFile 생성
        return new MockMultipartFile(
                "file",
                filename,
                contentType,
                content
        );
    }
}
