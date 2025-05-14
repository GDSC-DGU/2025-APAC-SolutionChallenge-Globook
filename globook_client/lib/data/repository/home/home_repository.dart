import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/reader.dart';

abstract class HomeRepository {
  Future<ParagraphsInfo> getLastParagraphsInfo();
  Future<List<Book>> getLibraryBooks();
}
