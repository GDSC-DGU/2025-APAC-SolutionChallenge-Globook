import 'package:globook_client/domain/model/book.dart';

abstract class BookStoreRepository {
  Future<List<Book>> getTodayBooks(String category);
  Future<Map<String, List<Book>>> getAllCategoryBooks();
}
