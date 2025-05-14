import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/data/provider/reader/reader_provider.dart';
import 'package:globook_client/domain/model/reader.dart';

class ReaderProviderImpl extends BaseConnect implements ReaderProvider {
  @override
  Future<ResponseWrapper<ReaderResponse>> getTTSMDTextFirst(
      bool isFile, int fileId, int index) async {
    final inputType = isFile ? 'FILE' : 'BOOK';
    final response = await get(
        '/api/v1/users/paragraphs?type=$inputType&fileId=$fileId&index=$index&direction=FIRST',
        headers: BaseConnect.usedAuthorization);
    LogUtil.info(response.body);
    if (response.statusCode == 200 && response.body['success'] == true) {
      final data = response.body['data'] as Map<String, dynamic>;
      final readerResponse = ReaderResponse.fromJson(data);
      return ResponseWrapper(success: true, data: readerResponse);
    } else {
      handleError(response.body['message']);
    }
    return ResponseWrapper(
        success: false, data: null, message: response.body['message']);
  }

  @override
  Future<ResponseWrapper<ReaderResponse>> getTTSMDTextAfter(
      bool isFile, int fileId, int index) async {
    final inputType = isFile ? 'FILE' : 'BOOK';
    final response = await get(
        '/api/v1/users/paragraphs?type=$inputType&fileId=$fileId&index=$index&direction=DOWN',
        headers: BaseConnect.usedAuthorization);
    if (response.statusCode == 200 && response.body['success'] == true) {
      final data = response.body['data'] as Map<String, dynamic>;
      final readerResponse = ReaderResponse.fromJson(data);
      return ResponseWrapper(success: true, data: readerResponse);
    } else {
      handleError(response.body['message']);
    }
    return ResponseWrapper(
        success: false, data: null, message: response.body['message']);
  }

  @override
  Future<ResponseWrapper<ReaderResponse>> getTTSMDTextBefore(
      bool isFile, int fileId, int index) async {
    final inputType = isFile ? 'FILE' : 'BOOK';
    final response = await get(
        '/api/v1/users/paragraphs?type=$inputType&fileId=$fileId&index=$index&direction=UP',
        headers: BaseConnect.usedAuthorization);
    if (response.statusCode == 200 && response.body['success'] == true) {
      final data = response.body['data'] as Map<String, dynamic>;
      final readerResponse = ReaderResponse.fromJson(data);
      return ResponseWrapper(success: true, data: readerResponse);
    } else {
      handleError(response.body['message']);
    }
    return ResponseWrapper(
        success: false, data: null, message: response.body['message']);
  }
}
