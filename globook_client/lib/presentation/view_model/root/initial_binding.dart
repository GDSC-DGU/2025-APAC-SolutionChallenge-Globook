import 'package:get/get.dart';
import 'package:globook_client/domain/usecase/auth/login_usecase.dart';
import 'package:globook_client/domain/usecase/book_store/book_store_usecase.dart';
import 'package:globook_client/domain/usecase/favorite/favorite_usecase.dart';
import 'package:globook_client/domain/usecase/home/home_usecase.dart';
import 'package:globook_client/domain/usecase/reader/reader_usecase.dart';
import 'package:globook_client/domain/usecase/storage/storage_usecase.dart';
import 'package:globook_client/domain/usecase/upload/upload_usecase.dart';
import 'package:globook_client/presentation/view_model/book_store/book_store_view_model.dart';
import 'package:globook_client/presentation/view_model/favorite/favorite_view_model.dart';
import 'package:globook_client/presentation/view_model/home/home_view_model.dart';
import 'package:globook_client/presentation/view_model/root/root_view_model.dart';
import 'package:globook_client/presentation/view_model/storage/storage_view_model.dart';
import 'package:globook_client/presentation/view_model/upload/upload_view_model.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // UseCase Dependency Injection
    Get.lazyPut<LoginUseCase>(() => LoginUseCase());
    Get.lazyPut<UploadUseCase>(() => UploadUseCase());
    Get.lazyPut<StorageUsecase>(() => StorageUsecase());
    Get.lazyPut<HomeUseCase>(() => HomeUseCase());
    Get.lazyPut<BookStoreUseCase>(() => BookStoreUseCase());
    Get.lazyPut<FavoriteUseCase>(() => FavoriteUseCase());
    Get.lazyPut<ReaderUseCase>(() => ReaderUseCase());

    // ViewModel Dependency Injection
    Get.lazyPut<RootViewModel>(() => RootViewModel());
    Get.lazyPut<UploadViewModel>(() => UploadViewModel());
    Get.lazyPut<StorageViewModel>(() => StorageViewModel());
    Get.lazyPut<HomeViewModel>(() => HomeViewModel());
    Get.lazyPut<BookStoreViewModel>(() => BookStoreViewModel());
    Get.lazyPut<FavoriteViewModel>(() => FavoriteViewModel());
  }
}
