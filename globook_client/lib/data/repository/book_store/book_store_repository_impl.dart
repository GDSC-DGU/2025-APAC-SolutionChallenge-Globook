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
  Future<List<Book>> getTodayBooks() async {
    final response = await _bookStoreProvider.getTodayBooks();
    return response.data!;
  }

  @override
  Future<List<Book>> getNonFictionBooks() async {
    final response = await _bookStoreProvider.getNonFictionBooks();
    return response.data!;
  }

  @override
  Future<List<Book>> getPhilosophyBooks() async {
    final response = await _bookStoreProvider.getPhilosophyBooks();
    return response.data!;
  }
}
