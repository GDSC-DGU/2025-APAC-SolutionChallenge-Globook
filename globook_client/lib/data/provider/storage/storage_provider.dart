import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/file.dart';

abstract class StorageProvider {
  Future<ResponseWrapper<List<UserFile>>> getUserFiles();
  Future<ResponseWrapper<List<Book>>> getUserBooks();
}
