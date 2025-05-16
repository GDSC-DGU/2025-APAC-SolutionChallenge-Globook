# Globook Server

The server is the backend system that processes PDF documents, manages books and user data, and provides APIs for the client application. For details on specific processing pipelines, see PDF Processing Pipeline.

## Tech Stack
| Component | Technology | Purpose |
| --- | --- | --- |
| Core Framework | Spring Boot 3.4.5 | Application framework |
| Database Access | Spring Data JPA | ORM for database operations |
| Security | Spring Security | Authentication and authorization |
| Authentication | JWT | Token-based authentication |
| Storage | Google Cloud Storage | Cloud storage for files and audio |
| Text-to-Speech | Google Cloud TTS | Converting text to speech |
| Translation | Gemini AI API | Translation of text content |
| Database | MySQL | Relational database |

## PDF Processing Pipeline

### Core Components and Interactions

The pipeline is implemented using a ports and adapters architecture (hexagonal architecture), which allows for clear separation of concerns and easier testing. The `ParagraphService` orchestrates the flow while interfacing with adapter implementations through port interfaces.

![image](https://github.com/user-attachments/assets/c5ce17e1-e4b2-4e05-8215-0566d5d9a338)

### Pipeline Execution Flow

#### File Creation and PDF to Markdown Conversion
The process begins with a file upload through the `ParagraphController`. A `File` entity is created with initial status, and the PDF is sent for conversion to markdown.

![Image](https://github.com/user-attachments/assets/61b5e7f1-ee09-445a-b252-accab7abe57a)

#### Markdown Processing and Paragraph Creation

After successful conversion, a second API call initiates the processing of the markdown:

1. Image URLs are processed within the markdown
2. Markdown is split into manageable chunks
3. Each chunk is translated in parallel
4. Paragraphs are extracted from the translated content
5. Paragraphs are stored in the database
6. Text-to-speech processing generates audio for each paragraph

![image](https://github.com/user-attachments/assets/034f6962-5f1b-4128-8461-87087d277053)

### Key Processing Components

#### PDF to Markdown Conversion

The `PdfToMarkdownAdapter` handles conversion by:

- Converting PDF to a ByteArrayResource
- Sending a multipart/form-data request to an external service
- Polling for results until conversion is complete

#### Markdown Splitting

The `TranslateMarkdownAdapter` uses Gemini AI to translate content while:

- Preserving markdown formatting
- Handling instructions to translate to target language
- Using retry mechanisms for resilience

#### Paragraph Extraction

The `MarkdownToParagraphAdapter` extracts meaningful paragraphs by:

- Using Gemini AI to identify logical paragraph boundaries
- Ensuring each paragraph contains approximately 2 sentences
- Preserving markdown formatting within paragraphs
- Returning a list of paragraph strings

#### Text-to-Speech Generation

The `TTSAdapter` generates audio for each paragraph by:

- First generalizing the text for better pronunciation
- Sending a request to Google's TTS service with language and persona parameters
- Uploading the generated audio to Google Cloud Storage
- Returning a public URL for the audio file

### Parallel Processing and Performance Optimization

The pipeline leverages parallel processing for computationally intensive tasks:

- Markdown Translation: All chunks are translated in parallel
- Paragraph Extraction: Paragraph extraction from translated chunks runs in parallel
- Text-to-Speech Generation: Audio generation for all paragraphs runs in parallel

This is implemented using Java's `CompletableFuture` with a fixed thread pool executor.

``` java
// Example of parallel processing pattern used throughout the pipeline
ExecutorService executor = Executors.newFixedThreadPool(50);
List<CompletableFuture<String>> futures = inputList.stream()
    .map(input -> CompletableFuture.supplyAsync(() -> 
        processItem(input), executor))
    .toList();
List<String> results = futures.stream()
    .map(CompletableFuture::join)
    .toList();
```

## Project Architecture

### ERD
![스크린샷 2025-05-14 오후 4 58 17](https://github.com/user-attachments/assets/1b6d4b48-40bc-42d5-a5b7-077a869b1f33)

### Directory Structure

```
📦 src
└── 📂 main
    └── 📂 java
        └── 📂 org
            └── 📂 gdsc
                └── 📂 globook
                    ├── 📂 application
                    │   ├── 📂 dto
                    │   ├── 📂 port
                    │   ├── 📂 repository
                    │   ├── 📂 response
                    │   └── 📂 service
                    │
                    ├── 📂 core
                    │   ├── 📂 annotation
                    │   ├── 📂 common
                    │   ├── 📂 config
                    │   ├── 📂 constant
                    │   ├── 📂 exception
                    │   ├── 📂 interceptor
                    │   ├── 📂 security
                    │   └── 📂 util
                    │
                    ├── 📂 domain
                    │   ├── 📂 entity
                    │   └── 📂 type
                    │
                    ├── 📂 infrastructure
                    │   ├── 📂 adapter
                    │   └── 📂 gRPC
                    │
                    └── 📂 presentation
                        ├── 📂 controller
                        └── 📂 request
```

