import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/book.dart';

abstract class FavoriteProvider {
  Future<ResponseWrapper<List<Book>>> getFavoriteBooks();
  Future<ResponseWrapper<void>> removeFavoriteBook(int bookId);
}
