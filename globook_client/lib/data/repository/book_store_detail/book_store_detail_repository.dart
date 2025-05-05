import 'package:globook_client/domain/model/book.dart';

abstract class BookStoreDetailRepository {
  Future<void> downloadBook(String bookId);
  Future<Book> getBookStoreDetail(String bookId);
  Future<void> addFavoriteBook(String bookId);
  Future<void> removeFavoriteBook(String bookId);
  Future<List<Book>> getCategoryBooks();
}
