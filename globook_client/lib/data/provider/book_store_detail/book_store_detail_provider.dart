import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/book.dart';

abstract class BookStoreDetailProvider {
  Future<ResponseWrapper<Book>> getBookStoreDetail(int bookId);
  Future<ResponseWrapper<bool>> addFavoriteBook(int bookId);
  Future<ResponseWrapper<bool>> removeFavoriteBook(int bookId);
  Future<ResponseWrapper<bool>> downloadBook(
      int bookId, String language, String persona);
}
