import 'package:get/get.dart';
import 'package:globook_client/domain/usecase/favorite/favorite_usecase.dart';
import 'package:globook_client/domain/usecase/reader/reader_usecase.dart';
import 'package:globook_client/presentation/view_model/favorite/favorite_view_model.dart';
import 'package:globook_client/presentation/view_model/reader/reader_view_model.dart';

class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoriteViewModel>(() => FavoriteViewModel());
    Get.lazyPut<FavoriteUseCase>(() => FavoriteUseCase());
  }
}
