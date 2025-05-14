import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/data/provider/home/home_provider.dart';

class HomeProviderImpl extends BaseConnect implements HomeProvider {
  @override
  Future<ResponseWrapper<List<Book>>> getLibraryBooks() async {
    final response = await get(
      '/api/v1/users/books?',
      headers: BaseConnect.usedAuthorization,
    );
    if (response.statusCode == 200 &&
        response.body != null &&
        response.body['success'] == true) {
      final data = response.body['data'];
      if (data != null && data['books'] != null) {
        final books = (data['books'] as List)
            .map((e) => Book.fromJson(e as Map<String, dynamic>))
            .toList();
        return ResponseWrapper(success: true, data: books);
      } else {
        return ResponseWrapper(success: true, data: []);
      }
    } else {
      final errorMessage = response.body['message'] ?? '내 책 목록을 불러오는데 실패했습니다.';
      handleError(errorMessage);
      return ResponseWrapper(success: false, data: [], message: errorMessage);
    }
  }
}
