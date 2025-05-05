// lib/presentation/view_model/upload/upload_view_model.dart
import 'dart:core';
import 'package:file_picker/file_picker.dart' as picker;
import 'package:get/get.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/domain/enum/Efile.dart';
import 'dart:io';
import 'package:globook_client/domain/model/file.dart';
import 'package:globook_client/domain/usecase/upload/upload_usecase.dart';

class UploadViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */

  /* -----------Dependency Injection of UseCase------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final UploadUseCase _uploadUseCase;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxList<UserFile> _uploadedFiles = RxList<UserFile>();
  final RxBool _isUploading = RxBool(false);
  final RxString _searchQuery = RxString('');

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  List<UserFile> get uploadedFiles => _uploadedFiles;
  bool get isUploading => _isUploading.value;
  String get searchQuery => _searchQuery.value;

  @override
  void onInit() async {
    super.onInit();
    // Dependency Injection
    _uploadUseCase = Get.find<UploadUseCase>();

    // 초기 데이터 로드
    loadFiles();
  }

  void loadFiles() async {
    // 임시 데이터
    final response = await _uploadUseCase.getUserFiles();
    _uploadedFiles.value = response;
  }

  void searchFiles(String query) {
    if (query.isEmpty) {
      loadFiles();
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final filteredFiles = _uploadedFiles
        .where((file) => file.name.toLowerCase().contains(lowercaseQuery))
        .toList();

    _uploadedFiles.value = filteredFiles;
  }

  void uploadFile() async {
    _isUploading.value = true;
    try {
      final result = await picker.FilePicker.platform.pickFiles(
        type: picker.FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        // TODO: 실제 파일 업로드 구현
        await _uploadUseCase.uploadFile(file);

        // 임시로 업로드된 파일 추가
        _uploadedFiles.add(UserFile(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: result.files.single.name,
          previewUrl: 'https://example.com/preview.jpg',
          fileUrl: file.path,
          fileType: FileType.pdf,
          status: FileStatus.uploading,
          uploadedAt: DateTime.now(),
        ));
      }
    } catch (e) {
      print('Error picking file: $e');
    } finally {
      _isUploading.value = false;
    }
  }

  void readFile(UserFile file) {
    if (file.status != FileStatus.completed) {
      return;
    }
    // TODO: 파일 읽기 구현
    print('Reading file: ${file.name}');
  }

  Future<void> pickAndUploadFile() async {
    picker.FilePickerResult? result =
        await picker.FilePicker.platform.pickFiles(
      type: picker.FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'hwp'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      // 파일 업로드 로직
      // uploadFileToServer(file);
    }
  }
}
