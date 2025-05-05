import 'dart:io';

import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/file.dart';

abstract class UploadProvider {
  Future<ResponseWrapper<List<UserFile>>> getUserFiles();
  Future<ResponseWrapper<void>> uploadFile(File file);
}
