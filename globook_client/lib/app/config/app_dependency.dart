import 'package:get/get.dart';
import 'package:globook_client/data/provider/auth/auth_provider.dart';
import 'package:globook_client/data/provider/auth/auth_provider_impl.dart';
import 'package:globook_client/data/provider/book_store/book_store_provider.dart';
import 'package:globook_client/data/provider/book_store/book_store_provider_impl.dart';
import 'package:globook_client/data/provider/book_store_detail/book_store_detail_provider.dart';
import 'package:globook_client/data/provider/book_store_detail/book_store_detail_provider_impl.dart';
import 'package:globook_client/data/provider/favorite/favorite_provider.dart';
import 'package:globook_client/data/provider/favorite/favorite_provider_impl.dart';
import 'package:globook_client/data/provider/home/home_provider.dart';
import 'package:globook_client/data/provider/home/home_provider_impl.dart';
import 'package:globook_client/data/provider/reader/reader_provider.dart';
import 'package:globook_client/data/provider/reader/reader_provider_impl.dart';
import 'package:globook_client/data/provider/storage/storage_provider.dart';
import 'package:globook_client/data/provider/storage/storage_provider_impl.dart';
import 'package:globook_client/data/provider/upload/upload_provider.dart';
import 'package:globook_client/data/provider/upload/upload_provider_impl.dart';
import 'package:globook_client/data/repository/auth/google_login_repository.dart';
import 'package:globook_client/data/repository/auth/google_login_repository_impl.dart';
import 'package:globook_client/data/repository/auth/login_repository.dart';
import 'package:globook_client/data/repository/auth/login_repository_impl.dart';
import 'package:globook_client/data/repository/book_store/book_store_repository.dart';
import 'package:globook_client/data/repository/book_store/book_store_repository_impl.dart';
import 'package:globook_client/data/repository/book_store_detail/book_store_detail_repository.dart';
import 'package:globook_client/data/repository/book_store_detail/book_store_detail_repository_impl.dart';
import 'package:globook_client/data/repository/favorite/favorite_repository.dart';
import 'package:globook_client/data/repository/favorite/favorite_repository_impl.dart';
import 'package:globook_client/data/repository/home/home_repository.dart';
import 'package:globook_client/data/repository/home/home_repository_impl.dart';
import 'package:globook_client/data/repository/reader/reader_repository_impl.dart';
import 'package:globook_client/data/repository/reader/reader_respository.dart';
import 'package:globook_client/data/repository/storage/storage_repository.dart';
import 'package:globook_client/data/repository/storage/storage_repository_impl.dart';
import 'package:globook_client/data/repository/upload/upload_repository.dart';
import 'package:globook_client/data/repository/upload/upload_repository_impl.dart';
import 'package:globook_client/domain/usecase/auth/google_login_usecase.dart';
import 'package:globook_client/domain/usecase/auth/login_usecase.dart';
import 'package:globook_client/domain/usecase/book_store/book_store_usecase.dart';
import 'package:globook_client/domain/usecase/book_store_detail/book_store_detail_usecase.dart';
import 'package:globook_client/domain/usecase/favorite/favorite_usecase.dart';
import 'package:globook_client/domain/usecase/home/home_usecase.dart';
import 'package:globook_client/domain/usecase/reader/reader_usecase.dart';
import 'package:globook_client/domain/usecase/storage/storage_usecase.dart';
import 'package:globook_client/domain/usecase/upload/upload_usecase.dart';

class AppDependency extends Bindings {
  @override
  void dependencies() {
    // Add your provider dependencies here
    Get.lazyPut<AuthProvider>(() => AuthProviderImpl());
    Get.lazyPut<GoogleLoginRepository>(() => GoogleLoginRepositoryImpl());
    Get.lazyPut<HomeProvider>(() => HomeProviderImpl());
    Get.lazyPut<BookStoreProvider>(() => BookStoreProviderImpl());
    Get.lazyPut<BookStoreDetailProvider>(() => BookStoreDetailProviderImpl());
    Get.lazyPut<UploadProvider>(() => UploadProviderImpl());
    Get.lazyPut<StorageProvider>(() => StorageProviderImpl());
    Get.lazyPut<ReaderProvider>(() => ReaderProviderImpl());
    Get.lazyPut<FavoriteProvider>(() => FavoriteProviderImpl());
    // Add your repository dependencies here
    Get.lazyPut<LoginRepository>(() => LoginRepositoryImpl());
    Get.lazyPut<GoogleLoginRepository>(() => GoogleLoginRepositoryImpl());
    Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl());
    Get.lazyPut<BookStoreRepository>(() => BookStoreRepositoryImpl());
    Get.lazyPut<BookStoreDetailRepository>(
        () => BookStoreDetailRepositoryImpl());
    Get.lazyPut<UploadRepository>(() => UploadRepositoryImpl());
    Get.lazyPut<StorageRepository>(() => StorageRepositoryImpl());
    Get.lazyPut<ReaderRepository>(() => ReaderRepositoryImpl());
    Get.lazyPut<FavoriteRepository>(() => FavoriteRepositoryImpl());
    // Add your usecase dependencies here
    Get.lazyPut<LoginUseCase>(() => LoginUseCase());
    Get.lazyPut<GoogleLoginUseCase>(() => GoogleLoginUseCase());
    Get.lazyPut<HomeUseCase>(() => HomeUseCase());
    Get.lazyPut<BookStoreUseCase>(() => BookStoreUseCase());
    Get.lazyPut<BookStoreDetailUseCase>(() => BookStoreDetailUseCase());
    Get.lazyPut<UploadUseCase>(() => UploadUseCase());
    Get.lazyPut<StorageUsecase>(() => StorageUsecase());
    Get.lazyPut<ReaderUseCase>(() => ReaderUseCase());
    Get.lazyPut<FavoriteUseCase>(() => FavoriteUseCase());
  }
}
