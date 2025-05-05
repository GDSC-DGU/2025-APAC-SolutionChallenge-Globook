import 'package:globook_client/domain/model/book.dart';

abstract class BookStoreRepository {
  Future<List<Book>> getTodayBooks();
  Future<List<Book>> getNonFictionBooks();
  Future<List<Book>> getPhilosophyBooks();
}
