import 'dart:io';

import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/data/provider/upload/upload_provider.dart';
import 'package:globook_client/domain/enum/Efile.dart';
import 'package:globook_client/domain/model/file.dart';

class UploadProviderImpl extends BaseConnect implements UploadProvider {
  @override
  Future<ResponseWrapper<List<UserFile>>> getUserFiles() async {
    return ResponseWrapper(data: [
      UserFile(
        id: '1',
        name: 'Policy.pdf',
        previewUrl: 'https://example.com/preview1.jpg',
        fileUrl: 'https://example.com/file1.pdf',
        fileType: FileType.pdf,
        uploadedAt: DateTime.now(),
        status: FileStatus.uploading,
      ),
      UserFile(
        id: '2',
        name: 'Terms.pdf',
        previewUrl: 'https://example.com/preview2.jpg',
        fileUrl: 'https://example.com/file2.pdf',
        fileType: FileType.pdf,
        uploadedAt: DateTime.now(),
        status: FileStatus.translating,
      ),
      UserFile(
        id: '3',
        name: 'Privacy.pdf',
        previewUrl: 'https://example.com/preview3.jpg',
        fileUrl: 'https://example.com/file3.pdf',
        fileType: FileType.pdf,
        uploadedAt: DateTime.now(),
        status: FileStatus.completed,
      ),
    ], success: true);
  }

  @override
  Future<ResponseWrapper<void>> uploadFile(File file) async {
    return ResponseWrapper(data: null, success: true);
  }
}
