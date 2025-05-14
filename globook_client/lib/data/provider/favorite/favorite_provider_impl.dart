import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/data/provider/favorite/favorite_provider.dart';

class FavoriteProviderImpl extends BaseConnect implements FavoriteProvider {
  @override
  Future<ResponseWrapper<List<Book>>> getFavoriteBooks() async {
    final response = await get('/api/v1/users/books/favorites',
        headers: BaseConnect.usedAuthorization);
    if (response.statusCode == 200 &&
        response.body != null &&
        response.body['success'] == true) {
      final data = response.body['data'];
      if (data != null && data['favoriteBooks'] != null) {
        final books = (data['favoriteBooks'] as List)
            .map((e) => Book.fromJson(e as Map<String, dynamic>))
            .toList();
        return ResponseWrapper(success: true, data: books);
      } else {
        return ResponseWrapper(success: true, data: []);
      }
    } else {
      final errorMessage = response.body['message'] ?? '즐겨찾기 목록을 불러오는데 실패했습니다.';
      handleError(errorMessage);
      return ResponseWrapper(success: false, data: [], message: errorMessage);
    }
  }

  @override
  Future<ResponseWrapper<void>> removeFavoriteBook(int bookId) async {
    final response = await delete('/api/v1/users/books/$bookId',
        headers: BaseConnect.usedAuthorization);
    if (response.statusCode == 200 && response.body['success'] == true) {
      return ResponseWrapper(success: true, data: null);
    }
    final errorMessage = response.body['message'] ?? '즐겨찾기 제거에 실패했습니다.';
    handleError(errorMessage);
    return ResponseWrapper(success: false, data: null, message: errorMessage);
  }
}
