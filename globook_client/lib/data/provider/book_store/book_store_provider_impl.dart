import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/data/provider/book_store/book_store_provider.dart';
import 'package:globook_client/domain/model/book.dart';

class BookStoreProviderImpl extends BaseConnect implements BookStoreProvider {
  @override
  Future<ResponseWrapper<List<Book>>> getTodayBooks(String category) async {
    try {
      final response = await get('/api/v1/books/today?category=$category',
          headers: BaseConnect.usedAuthorization);
      LogUtil.info(response.body);

      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> books = response.body['data']['randomBooks'];
        final List<Book> todayBooks =
            books.map((book) => Book.fromJson(book)).toList();

        return ResponseWrapper(success: true, data: todayBooks);
      } else {
        final errorMessage = response.body['message'] ?? '도서 목록을 불러오는데 실패했습니다.';
        handleError(errorMessage);
        return ResponseWrapper(success: false, data: [], message: errorMessage);
      }
    } catch (e) {
      handleError('서버 연결에 실패했습니다. ${e.toString()}');
      return ResponseWrapper(success: false, data: [], message: e.toString());
    }
  }

  @override
  Future<ResponseWrapper<Map<String, List<Book>>>> getAllCategoryBooks() async {
    try {
      final response =
          await get('/api/v1/books', headers: BaseConnect.usedAuthorization);
      LogUtil.info(response.body);
      if (response.statusCode == 200 && response.body['success'] == true) {
        final Map<String, dynamic> booksByCategory =
            response.body['data']['booksByCategory'];
        Map<String, List<Book>> categorizedBooks = {};

        booksByCategory.forEach((category, books) {
          final List<dynamic> bookList = books as List<dynamic>;
          categorizedBooks[category] =
              bookList.map((book) => Book.fromJson(book)).toList();
        });

        return ResponseWrapper(success: true, data: categorizedBooks);
      } else {
        final errorMessage = response.body['message'] ?? '도서 목록을 불러오는데 실패했습니다.';
        handleError(errorMessage);
        return ResponseWrapper(success: false, data: {}, message: errorMessage);
      }
    } catch (e) {
      handleError('서버 연결에 실패했습니다. ${e.toString()}');
      return ResponseWrapper(success: false, data: {}, message: e.toString());
    }
  }
}
