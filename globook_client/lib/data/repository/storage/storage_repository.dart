import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/file.dart';

abstract class StorageRepository {
  Future<List<UserFile>> getUserFiles();
  Future<List<Book>> getUserBooks();
  Future<void> readFile(int fileId, int index);
}
