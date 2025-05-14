import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/data/provider/upload/upload_provider.dart';
import 'package:globook_client/domain/model/file.dart';
import 'package:globook_client/presentation/view_model/storage/storage_view_model.dart';
import 'package:globook_client/presentation/view_model/upload/upload_view_model.dart';

class UploadProviderImpl extends BaseConnect implements UploadProvider {
  @override
  Future<ResponseWrapper<List<UserFile>>> getUserFiles() async {
    final response = await get('/api/v1/users/files',
        headers: BaseConnect.usedAuthorization);
    LogUtil.info(response);

    if (response.statusCode == 200 && response.body['success'] == true) {
      final data = response.body['data']['files'] as List<dynamic>;
      final List<UserFile> userFiles = data
          .map((file) => UserFile.fromJson(file as Map<String, dynamic>))
          .toList();
      return ResponseWrapper(success: true, data: userFiles);
    }
    final errorMessage = response.body['message'] ?? 'Failed to load file list';
    handleError(errorMessage);
    return ResponseWrapper(success: false, data: [], message: errorMessage);
  }

  @override
  Future<ResponseWrapper<void>> uploadFile(
      File file, String language, String persona) async {
    final formData = FormData({
      'file': MultipartFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: 'multipart/form-data',
      ),
    });

    final headers = Map<String, String>.from(BaseConnect.usedAuthorization);

    final response = await post(
      '/api/v1/users/files/upload?targetLanguage=$language&persona=$persona',
      formData,
      headers: headers,
    );

    if (response.statusCode == 200 && response.body['success'] == true) {
      final responseData = response.body['data'];
      LogUtil.info(responseData);

      final translateResponse = await post(
        '/api/v1/users/files/translate?targetLanguage=$language&persona=$persona',
        responseData,
        headers: headers,
      );

      if (translateResponse.statusCode == 200) {
        LogUtil.debug('번역 요청 완료: $translateResponse');
        Get.find<UploadViewModel>().loadFiles();
        Get.find<StorageViewModel>().loadData();
      } else {
        handleError('번역 도중 오류 발생: ${translateResponse.body['message']}');
      }

      return ResponseWrapper(success: true, data: null);
    }
    final errorMessage = response.body['message'] ?? 'Failed to upload file';
    handleError(errorMessage);
    return ResponseWrapper(success: false, data: null, message: errorMessage);
  }
}
