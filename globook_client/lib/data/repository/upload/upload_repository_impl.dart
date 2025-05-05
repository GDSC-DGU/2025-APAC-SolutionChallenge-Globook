import 'package:get/get.dart';
import 'package:globook_client/data/provider/upload/upload_provider.dart';
import 'package:globook_client/data/repository/upload/upload_repository.dart';
import 'package:globook_client/domain/model/file.dart';
import 'dart:io';

class UploadRepositoryImpl extends GetxService implements UploadRepository {
  late UploadProvider _uploadProvider;

  @override
  void onInit() {
    super.onInit();
    _uploadProvider = Get.find<UploadProvider>();
  }

  @override
  Future<List<UserFile>> getUserFiles() async {
    final response = await _uploadProvider.getUserFiles();
    return response.data!;
  }

  @override
  Future<void> uploadFile(File file) async {
    final response = await _uploadProvider.uploadFile(file);
    return response.data;
  }
}
