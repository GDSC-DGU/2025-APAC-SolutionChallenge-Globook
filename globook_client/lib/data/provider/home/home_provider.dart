import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/book.dart';

abstract class HomeProvider {
  Future<ResponseWrapper<List<Book>>> getLibraryBooks();
}
