import 'package:globook_client/domain/model/book.dart';

abstract class FavoriteRepository {
  Future<List<Book>> getFavoriteBooks();
  Future<void> removeFavoriteBook(int bookId);
  Future<void> readBook(int bookId);
}
