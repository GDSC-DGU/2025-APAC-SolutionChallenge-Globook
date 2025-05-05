import 'package:globook_client/domain/model/book.dart';

abstract class FavoriteRepository {
  Future<List<Book>> getFavoriteBooks();
  Future<void> removeFavoriteBook(String bookId);
  Future<void> readBook(String bookId);
}
