import 'package:globook_client/domain/model/book.dart';

abstract class HomeRepository {
  Future<Book> getLastReadBook();
  Future<List<Book>> getLibraryBooks();
}
