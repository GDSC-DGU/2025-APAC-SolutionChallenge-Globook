import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/data/provider/book_store_detail/book_store_detail_provider.dart';
import 'package:globook_client/domain/model/book.dart';

class BookStoreDetailProviderImpl extends BaseConnect
    implements BookStoreDetailProvider {
  @override
  Future<ResponseWrapper<Book>> getBookStoreDetail(int bookId) async {
    final response = await get('/api/v1/books/$bookId',
        headers: BaseConnect.usedAuthorization);
    if (response.statusCode == 200 && response.body['success'] == true) {
      return ResponseWrapper<Book>(
        success: true,
        data: Book.fromJson(response.body['data']),
      );
    }
    final errorMessage = response.body['message'] ?? '도서 목록을 불러오는데 실패했습니다.';
    handleError(errorMessage);
    return ResponseWrapper(success: false, data: null, message: errorMessage);
  }

  @override
  Future<ResponseWrapper<bool>> addFavoriteBook(int bookId) async {
    final response = await patch('/api/v1/users/books/$bookId', {},
        headers: BaseConnect.usedAuthorization);
    if (response.statusCode == 200 && response.body['success'] == true) {
      return ResponseWrapper<bool>(
        success: true,
        data: true,
      );
    }
    final errorMessage = response.body['message'] ?? '즐겨찾기 추가에 실패했습니다.';
    handleError(errorMessage);
    return ResponseWrapper(success: false, data: null, message: errorMessage);
  }

  @override
  Future<ResponseWrapper<bool>> removeFavoriteBook(int bookId) async {
    final response = await delete('/api/v1/users/books/$bookId',
        headers: BaseConnect.usedAuthorization);
    if (response.statusCode == 200 && response.body['success'] == true) {
      return ResponseWrapper<bool>(
        success: true,
        data: true,
      );
    }
    final errorMessage = response.body['message'] ?? '즐겨찾기 제거에 실패했습니다.';
    handleError(errorMessage);
    return ResponseWrapper(success: false, data: null, message: errorMessage);
  }

  @override
  Future<ResponseWrapper<bool>> downloadBook(
      int bookId, String language, String persona) async {
    LogUtil.info('downloadBook: $bookId, $language, $persona');
    final response = await patch(
        '/api/v1/users/books/$bookId/download',
        {
          'language': language,
          'persona': persona,
        },
        headers: BaseConnect.usedAuthorization);
    if (response.statusCode == 200 && response.body['success'] == true) {
      return ResponseWrapper<bool>(
        success: true,
        data: true,
      );
    }
    final errorMessage = response.body['message'] ?? '도서 다운로드에 실패했습니다.';
    handleError(errorMessage);
    return ResponseWrapper(success: false, data: null, message: errorMessage);
  }
}
