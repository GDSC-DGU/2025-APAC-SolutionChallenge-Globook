import 'package:get/get.dart';
import 'package:globook_client/core/usecase/base_usecase.dart';
import 'package:globook_client/data/repository/book_store_detail/book_store_detail_repository.dart';
import 'package:globook_client/domain/model/book.dart';

class BookStoreDetailUseCase extends BaseUseCase
    implements BookStoreDetailRepository {
  late final BookStoreDetailRepository _bookStoreDetailRepository;

  @override
  void onInit() {
    super.onInit();
    _bookStoreDetailRepository = Get.find<BookStoreDetailRepository>();
  }

  @override
  Future<void> addFavoriteBook(String bookId) {
    return _bookStoreDetailRepository.addFavoriteBook(bookId);
  }

  @override
  Future<Book> getBookStoreDetail(String bookId) {
    return _bookStoreDetailRepository.getBookStoreDetail(bookId);
  }

  @override
  Future<List<Book>> getCategoryBooks() {
    return _bookStoreDetailRepository.getCategoryBooks();
  }

  @override
  Future<void> removeFavoriteBook(String bookId) {
    return _bookStoreDetailRepository.removeFavoriteBook(bookId);
  }

  @override
  Future<void> downloadBook(String bookId) {
    return _bookStoreDetailRepository.downloadBook(bookId);
  }
}
