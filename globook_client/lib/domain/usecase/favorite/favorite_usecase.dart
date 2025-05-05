import 'package:get/get.dart';
import 'package:globook_client/core/usecase/base_usecase.dart';
import 'package:globook_client/data/repository/favorite/favorite_repository.dart';
import 'package:globook_client/domain/model/book.dart';

class FavoriteUseCase extends BaseUseCase implements FavoriteRepository {
  late final FavoriteRepository _favoriteRepository;

  @override
  void onInit() {
    super.onInit();
    _favoriteRepository = Get.find<FavoriteRepository>();
  }

  @override
  Future<List<Book>> getFavoriteBooks() async {
    return await _favoriteRepository.getFavoriteBooks();
  }

  @override
  Future<void> removeFavoriteBook(String bookId) async {
    await _favoriteRepository.removeFavoriteBook(bookId);
  }

  @override
  Future<void> readBook(String bookId) async {
    await _favoriteRepository.readBook(bookId);
  }
}
