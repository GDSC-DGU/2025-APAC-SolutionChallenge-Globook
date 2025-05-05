import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/book.dart';

abstract class BookStoreProvider {
  Future<ResponseWrapper<List<Book>>> getTodayBooks();
  Future<ResponseWrapper<List<Book>>> getNonFictionBooks();
  Future<ResponseWrapper<List<Book>>> getPhilosophyBooks();
}
