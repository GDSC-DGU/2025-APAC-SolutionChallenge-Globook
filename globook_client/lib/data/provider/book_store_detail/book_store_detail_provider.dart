import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/book.dart';

abstract class BookStoreDetailProvider {
  Future<ResponseWrapper<Book>> getBookStoreDetail(String bookId);
  Future<ResponseWrapper<void>> addFavoriteBook(String bookId);
  Future<ResponseWrapper<void>> removeFavoriteBook(String bookId);
  Future<ResponseWrapper<List<Book>>> getCategoryBooks();
  Future<ResponseWrapper<void>> downloadBook(String bookId);
}
