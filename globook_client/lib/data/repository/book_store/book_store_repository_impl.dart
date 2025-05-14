import 'package:get/get.dart';
import 'package:globook_client/data/provider/book_store/book_store_provider.dart';
import 'package:globook_client/data/repository/book_store/book_store_repository.dart';
import 'package:globook_client/domain/model/book.dart';

class BookStoreRepositoryImpl extends GetxService
    implements BookStoreRepository {
  late final BookStoreProvider _bookStoreProvider;

  @override
  void onInit() {
    super.onInit();
    _bookStoreProvider = Get.find<BookStoreProvider>();
  }

  @override
  Future<List<Book>> getTodayBooks(String category) async {
    final response = await _bookStoreProvider.getTodayBooks(category);
    return response.data!;
  }

  @override
  Future<Map<String, List<Book>>> getAllCategoryBooks() async {
    final response = await _bookStoreProvider.getAllCategoryBooks();
    return response.data!;
  }
}
