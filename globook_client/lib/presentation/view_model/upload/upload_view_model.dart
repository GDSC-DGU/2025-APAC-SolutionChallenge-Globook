// lib/presentation/view_model/upload/upload_view_model.dart
import 'dart:core';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:io';

class UploadViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */

  /* -----------Dependency Injection of UseCase------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  // 필요한 UseCase 주입 (예: UploadUseCase)

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxList<Map<String, dynamic>> _uploadedFiles =
      RxList<Map<String, dynamic>>([]);
  final RxBool _isUploading = RxBool(false);
  final RxString _searchQuery = RxString('');

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  List<Map<String, dynamic>> get uploadedFiles => _uploadedFiles;
  bool get isUploading => _isUploading.value;
  String get searchQuery => _searchQuery.value;

  @override
  void onInit() async {
    super.onInit();
    // Dependency Injection
    // _uploadUseCase = Get.find<UploadUseCase>();

    // 초기 데이터 로드
    loadUploadedFiles();
  }

  void loadUploadedFiles() {
    // 예시 데이터
    _uploadedFiles.addAll([
      {
        'fileName': '파일명.hwp',
        'fileType': 'hwp',
        'uploadTime': '오늘',
        'status': '업로드 중'
      },
      {
        'fileName': '파일명.pdf',
        'fileType': 'pdf',
        'uploadTime': '어제',
        'status': '번역 중'
      },
      {
        'fileName': '파일명.pdf',
        'fileType': 'pdf',
        'uploadTime': '4/1',
        'status': '완료',
        'pages': 1
      },
      {
        'fileName': '파일명.pdf',
        'fileType': 'pdf',
        'uploadTime': '4/1',
        'status': '완료',
        'pages': 1
      },
      {
        'fileName': '파일명.pdf',
        'fileType': 'pdf',
        'uploadTime': '4/1',
        'status': '완료',
        'pages': 1
      }
    ]);
  }

  void uploadFile() async {
    _isUploading.value = true;
    // 파일 업로드 로직
    // ...
    await Future.delayed(const Duration(seconds: 2)); // 업로드 시뮬레이션
    _isUploading.value = false;

    // 업로드 성공 후 목록에 추가
    _uploadedFiles.insert(0, {
      'fileName': '새파일.pdf',
      'fileType': 'pdf',
      'uploadTime': '방금',
      'status': '업로드 중'
    });
  }

  void readFile(Map<String, dynamic> file) {
    // 파일 읽기 화면으로 이동
    print('Reading file: ${file['fileName']}');
  }

  void searchFiles(String query) {
    _searchQuery.value = query;
    // 검색 로직 구현
  }

  Future<void> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'hwp'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      // 파일 업로드 로직
      // uploadFileToServer(file);
    }
  }
}
