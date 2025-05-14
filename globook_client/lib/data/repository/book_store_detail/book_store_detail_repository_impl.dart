import 'package:get/get.dart';
import 'package:globook_client/data/provider/book_store_detail/book_store_detail_provider.dart';
import 'package:globook_client/data/repository/book_store_detail/book_store_detail_repository.dart';
import 'package:globook_client/domain/model/book.dart';

class BookStoreDetailRepositoryImpl extends GetxService
    implements BookStoreDetailRepository {
  late final BookStoreDetailProvider _bookStoreDetailProvider;

  @override
  void onInit() {
    super.onInit();
    _bookStoreDetailProvider = Get.find<BookStoreDetailProvider>();
  }

  @override
  Future<Book> getBookStoreDetail(int bookId) async {
    final response = await _bookStoreDetailProvider.getBookStoreDetail(bookId);
    return response.data!;
  }

  @override
  Future<bool> addFavoriteBook(int bookId) async {
    final response = await _bookStoreDetailProvider.addFavoriteBook(bookId);
    return response.data!;
  }

  @override
  Future<bool> removeFavoriteBook(int bookId) async {
    final response = await _bookStoreDetailProvider.removeFavoriteBook(bookId);
    return response.data!;
  }

  @override
  Future<bool> downloadBook(int bookId, String language, String persona) async {
    final response = await _bookStoreDetailProvider.downloadBook(
        bookId, language, persona);
    return response.data!;
  }
}
