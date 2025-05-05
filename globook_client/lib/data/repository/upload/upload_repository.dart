import 'dart:io';

import 'package:globook_client/domain/model/file.dart';

abstract class UploadRepository {
  Future<List<UserFile>> getUserFiles();
  Future<void> uploadFile(File file);
}
