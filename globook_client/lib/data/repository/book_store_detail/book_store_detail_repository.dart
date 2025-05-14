import 'package:globook_client/domain/model/book.dart';

abstract class BookStoreDetailRepository {
  Future<bool> downloadBook(int bookId, String language, String persona);
  Future<Book> getBookStoreDetail(int bookId);
  Future<bool> addFavoriteBook(int bookId);
  Future<bool> removeFavoriteBook(int bookId);
}
