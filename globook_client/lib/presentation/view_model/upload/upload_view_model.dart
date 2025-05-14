// lib/presentation/view_model/upload/upload_view_model.dart
import 'dart:core';
import 'package:file_picker/file_picker.dart' as picker;
import 'package:get/get.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/domain/enum/Efile.dart';
import 'dart:io';
import 'package:globook_client/domain/model/file.dart';
import 'package:globook_client/domain/usecase/upload/upload_usecase.dart';
import 'dart:async';

class UploadViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */
  static const int POLLING_INTERVAL = 3000; // 3초마다 체크

  /* -----------Dependency Injection of UseCase------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final UploadUseCase _uploadUseCase;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxList<UserFile> _uploadedFile = RxList<UserFile>();
  final RxBool _isUploading = RxBool(false);
  final RxString _searchQuery = RxString('');
  Timer? _pollingTimer;
  final RxMap<int, FileStatus> _fileStatusMap = RxMap<int, FileStatus>();
  final RxMap<int, DateTime> _lastCheckTime = RxMap<int, DateTime>();
  bool _isDisposed = false;
  int _tempFileId = -1; // 임시 파일 ID

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  List<UserFile> get uploadedFile => _uploadedFile;
  bool get isUploading => _isUploading.value;
  String get searchQuery => _searchQuery.value;
  Map<int, FileStatus> get fileStatusMap => _fileStatusMap;

  @override
  void onInit() async {
    super.onInit();
    _uploadUseCase = Get.find<UploadUseCase>();
    _isDisposed = false;
    loadFiles();
  }

  @override
  void onClose() {
    _isDisposed = true;
    _pollingTimer?.cancel();
    super.onClose();
  }

  void loadFiles() async {
    if (_isDisposed) return;

    final response = await _uploadUseCase.getUserFiles();
    if (_isDisposed) return;

    _uploadedFile.value = response;

    // 각 파일의 상태 업데이트
    for (final file in response) {
      _fileStatusMap[file.id] = file.fileStatus;
      _lastCheckTime[file.id] = DateTime.now();
    }

    // 처리 중인 파일이 있는지 확인하고 폴링 시작
    // _startPolling();
  }

  void _startPolling() {
    if (_isDisposed) return;

    _pollingTimer?.cancel();

    // 처리 중인 파일 찾기
    final processingFiles = _uploadedFile
        .where((file) => file.fileStatus == FileStatus.processing)
        .toList();

    if (processingFiles.isNotEmpty) {
      _pollingTimer = Timer.periodic(
        const Duration(milliseconds: POLLING_INTERVAL),
        (_) {
          if (!_isDisposed) {
            _checkFileStatuses(processingFiles);
          }
        },
      );
    }
  }

  Future<void> _checkFileStatuses(List<UserFile> files) async {
    if (_isDisposed) return;

    for (final file in files) {
      if (_isDisposed) return;

      try {
        // 마지막 체크 시간으로부터 3초가 지났는지 확인
        final lastCheck = _lastCheckTime[file.id];
        if (lastCheck != null &&
            DateTime.now().difference(lastCheck).inSeconds < 3) {
          continue;
        }

        // 파일 목록 새로고침
        final response = await _uploadUseCase.getUserFiles();
        if (_isDisposed) return;

        // 임시 파일이 처리 완료되면 제거
        if (file.id == _tempFileId) {
          final completedFile = response.firstWhere(
            (f) => f.title == file.title,
            orElse: () => file,
          );
          if (completedFile.fileStatus == FileStatus.read) {
            _tempFileId = -1;
          }
        }

        _uploadedFile.value = response;
        _lastCheckTime[file.id] = DateTime.now();
      } catch (e) {
        LogUtil.error('파일 상태 체크 중 오류 발생: $e');
      }
    }
  }

  void searchFiles(String query) {
    if (_isDisposed) return;

    if (query.isEmpty) {
      loadFiles();
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final filteredFiles = _uploadedFile
        .where((file) => file.title.toLowerCase().contains(lowercaseQuery))
        .toList();

    _uploadedFile.value = filteredFiles;
  }

  Future<File?> getFile() async {
    _isUploading.value = true;
    try {
      final result = await picker.FilePicker.platform.pickFiles(
        type: picker.FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        return file;
      }
    } catch (e) {
      print('Error picking file: $e');
    } finally {
      _isUploading.value = false;
    }
    return null;
  }

  Future<void> uploadFile(File file, String language, String persona) async {
    if (_isDisposed) return;

    _isUploading.value = true;
    try {
      // 임시 파일 생성
      final tempFile = UserFile(
        id: _tempFileId,
        title: file.path.split('/').last,
        language: language,
        fileStatus: FileStatus.processing,
        createdAt: DateTime.now(),
      );

      // 임시 파일 추가
      _uploadedFile.insert(0, tempFile);
      _fileStatusMap[_tempFileId] = FileStatus.processing;
      _lastCheckTime[_tempFileId] = DateTime.now();

      // 폴링 시작
      // _startPolling();

      // 실제 업로드 진행
      await _uploadUseCase.uploadFile(file, language, persona);
      if (!_isDisposed) {
        loadFiles(); // 파일 목록 새로고침
      }
    } finally {
      if (!_isDisposed) {
        _isUploading.value = false;
      }
    }
  }

  void readFile(UserFile file) {
    if (_isDisposed) return;

    if (file.fileStatus != FileStatus.read) {
      return;
    }
    // TODO: 파일 읽기 구현
    print('Reading file: ${file.title}');
  }

  Future<void> pickAndUploadFile() async {
    picker.FilePickerResult? result =
        await picker.FilePicker.platform.pickFiles(
      type: picker.FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      // 파일 업로드 로직
      // uploadFileToServer(file);
    }
  }
}
