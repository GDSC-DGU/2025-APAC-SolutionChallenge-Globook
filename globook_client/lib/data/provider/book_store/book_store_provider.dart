import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/book.dart';

abstract class BookStoreProvider {
  Future<ResponseWrapper<List<Book>>> getTodayBooks(String category);
  Future<ResponseWrapper<Map<String, List<Book>>>> getAllCategoryBooks();
}
