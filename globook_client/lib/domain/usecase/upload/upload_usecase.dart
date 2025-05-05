import 'dart:io';

import 'package:get/get.dart';
import 'package:globook_client/core/usecase/base_usecase.dart';
import 'package:globook_client/data/repository/upload/upload_repository.dart';
import 'package:globook_client/domain/model/file.dart';

class UploadUseCase extends BaseUseCase implements UploadRepository {
  late UploadRepository _uploadRepository;

  @override
  void onInit() {
    super.onInit();
    _uploadRepository = Get.find<UploadRepository>();
  }

  @override
  Future<List<UserFile>> getUserFiles() async {
    return await _uploadRepository.getUserFiles();
  }

  @override
  Future<void> uploadFile(File file) async {
    return await _uploadRepository.uploadFile(file);
  }
}
