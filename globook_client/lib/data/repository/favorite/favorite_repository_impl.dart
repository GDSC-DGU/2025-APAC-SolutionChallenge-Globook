import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/data/provider/favorite/favorite_provider.dart';
import 'package:globook_client/data/repository/favorite/favorite_repository.dart';
import 'package:globook_client/domain/model/book.dart';

class FavoriteRepositoryImpl extends GetxService implements FavoriteRepository {
  late final FavoriteProvider _favoriteProvider;

  @override
  void onInit() {
    super.onInit();
    _favoriteProvider = Get.find<FavoriteProvider>();
  }

  @override
  Future<List<Book>> getFavoriteBooks() async {
    final response = await _favoriteProvider.getFavoriteBooks();
    return response.data ?? [];
  }

  @override
  Future<void> removeFavoriteBook(int bookId) async {
    await _favoriteProvider.removeFavoriteBook(bookId);
  }

  @override
  Future<void> readBook(int bookId) async {
    Get.toNamed(AppRoutes.READER, arguments: bookId);
  }
}
