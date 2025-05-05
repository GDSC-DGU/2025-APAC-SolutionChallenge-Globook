import 'package:get/get.dart';
import 'package:globook_client/core/usecase/base_usecase.dart';
import 'package:globook_client/data/repository/book_store/book_store_repository.dart';
import 'package:globook_client/domain/model/book.dart';

class BookStoreUseCase extends BaseUseCase implements BookStoreRepository {
  late final BookStoreRepository _bookStoreRepository;

  @override
  void onInit() {
    super.onInit();
    _bookStoreRepository = Get.find<BookStoreRepository>();
  }

  @override
  Future<List<Book>> getTodayBooks() async {
    return await _bookStoreRepository.getTodayBooks();
  }

  @override
  Future<List<Book>> getNonFictionBooks() async {
    return await _bookStoreRepository.getNonFictionBooks();
  }

  @override
  Future<List<Book>> getPhilosophyBooks() async {
    return await _bookStoreRepository.getPhilosophyBooks();
  }
}
