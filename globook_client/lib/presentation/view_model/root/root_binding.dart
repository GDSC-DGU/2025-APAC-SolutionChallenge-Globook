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

class RootBinding extends Bindings {
  @override
  void dependencies() {
    // UseCase Dependency Injection
    Get.put<LoginUseCase>(LoginUseCase());
    Get.put<UploadUseCase>(UploadUseCase());
    Get.put<StorageUsecase>(StorageUsecase());
    Get.put<HomeUseCase>(HomeUseCase());
    Get.put<BookStoreUseCase>(BookStoreUseCase());
    Get.put<FavoriteUseCase>(FavoriteUseCase());
    Get.put<ReaderUseCase>(ReaderUseCase());

    // ViewModel Dependency Injection
    Get.put<RootViewModel>(RootViewModel());
    Get.put<UploadViewModel>(UploadViewModel());
    Get.put<StorageViewModel>(StorageViewModel());
    Get.put<HomeViewModel>(HomeViewModel());
    Get.put<BookStoreViewModel>(BookStoreViewModel());
    Get.put<FavoriteViewModel>(FavoriteViewModel());
  }
}
