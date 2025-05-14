import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/data/provider/storage/storage_provider.dart';
import 'package:globook_client/domain/enum/EbookCategory.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/file.dart';

class StorageProviderImpl extends BaseConnect implements StorageProvider {
  @override
  Future<ResponseWrapper<List<UserFile>>> getUserFiles() async {
    final response = await get('/api/v1/users/files',
        headers: BaseConnect.usedAuthorization);
    if (response.statusCode == 200 && response.body['success'] == true) {
      final data = response.body['data'];
      if (data != null && data['files'] != null) {
        final files = (data['files'] as List)
            .map((e) => UserFile.fromJson(e as Map<String, dynamic>))
            .toList();
        return ResponseWrapper(success: true, data: files);
      } else {
        return ResponseWrapper(success: true, data: []);
      }
    }
    final errorMessage = response.body['message'] ?? 'Failed to load file list';
    handleError(errorMessage);
    return ResponseWrapper(success: false, data: [], message: errorMessage);
  }

  @override
  Future<ResponseWrapper<List<Book>>> getUserBooks() async {
    final response = await get('/api/v1/users/books',
        headers: BaseConnect.usedAuthorization);
    if (response.statusCode == 200 && response.body['success'] == true) {
      final data = response.body['data'];
      if (data != null && data['books'] != null) {
        final books = (data['books'] as List)
            .map((e) => Book.fromJson(e as Map<String, dynamic>))
            .toList();
        return ResponseWrapper(success: true, data: books);
      } else {
        return ResponseWrapper(success: true, data: []);
      }
    }
    final errorMessage = response.body['message'] ?? 'Failed to load book list';
    handleError(errorMessage);
    return ResponseWrapper(success: false, data: [], message: errorMessage);
  }

  @override
  Future<ResponseWrapper<void>> readFile(int fileId, int index) async {
    final response = await get(
        '/api/v1/users/paragraphs?fileId=$fileId&index=$index',
        headers: BaseConnect.usedAuthorization);
    if (response.statusCode == 200 && response.body['success'] == true) {
      return ResponseWrapper(success: true, data: null);
    }
    final errorMessage = response.body['message'] ?? 'Failed to read file';
    handleError(errorMessage);
    return ResponseWrapper(success: false, data: null, message: errorMessage);
  }
}
