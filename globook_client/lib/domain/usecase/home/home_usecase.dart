import 'package:get/get.dart';
import 'package:globook_client/core/usecase/base_usecase.dart';
import 'package:globook_client/data/repository/home/home_repository.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/app/utility/log_util.dart';

class HomeUseCase extends BaseUseCase implements HomeRepository {
  late final HomeRepository _homeRepository;

  @override
  void onInit() {
    super.onInit();
    _homeRepository = Get.find<HomeRepository>();
  }

  @override
  Future<Book> getLastReadBook() async {
    final book = await _homeRepository.getLastReadBook();
    return book;
  }

  @override
  Future<List<Book>> getLibraryBooks() async {
    final books = await _homeRepository.getLibraryBooks();
    return books;
  }
}
