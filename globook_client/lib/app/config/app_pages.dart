import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/app/middleware/login_middleware.dart';
import 'package:globook_client/presentation/view/book_store/book_store_screen.dart';
import 'package:globook_client/presentation/view/book_store_detail/book_store_detail_screen.dart';
import 'package:globook_client/presentation/view/favorite/favorite_screen.dart';
import 'package:globook_client/presentation/view/genre_books/genre_books_screen.dart';
import 'package:globook_client/presentation/view/home/home_screen.dart';
import 'package:globook_client/presentation/view/login/login_screen.dart';
import 'package:globook_client/presentation/view/reader/reader_screen.dart';
import 'package:globook_client/presentation/view/register/register_screen.dart';
import 'package:globook_client/presentation/view/root/root_screen.dart';
import 'package:globook_client/presentation/view/splash/splash_screen.dart';
import 'package:globook_client/presentation/view/storage/storage_screen.dart';
import 'package:globook_client/presentation/view/upload/upload_screen.dart';
import 'package:globook_client/presentation/view_model/book_store_detail/book_store_detail_binding.dart';
import 'package:globook_client/presentation/view_model/favorite/favorite_binding.dart';
import 'package:globook_client/presentation/view_model/genre_books/genre_books_binding.dart';
import 'package:globook_client/presentation/view_model/login/login_binding.dart';
import 'package:globook_client/presentation/view_model/reader/reader_binding.dart';
import 'package:globook_client/presentation/view_model/register/register_binding.dart';
import 'package:globook_client/presentation/view_model/root/root_binding.dart';

abstract class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.ROOT,
      page: () => const RootScreen(),
      binding: RootBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.BOOK_STORE,
      page: () => const BookStoreScreen(),
    ),
    GetPage(
      name: AppRoutes.STORAGE,
      page: () => const StorageScreen(),
    ),
    GetPage(
      name: AppRoutes.UPLOAD,
      page: () => const UploadScreen(),
    ),
    //-----------Below Pages Need Binding------------//
    GetPage(
      name: AppRoutes.BOOK_STORE_DETAIL,
      page: () => const BookStoreDetailScreen(),
      binding: BookStoreDeatilBinding(),
    ),
    GetPage(
      name: AppRoutes.GENRE_BOOKS,
      page: () => const GenreBooksScreen(),
      binding: GenreBooksBinding(),
    ),
    GetPage(
      name: AppRoutes.READER,
      page: () => const ReaderScreen(),
      binding: ReaderBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.FAVORITE,
      page: () => const FavoriteScreen(),
      binding: FavoriteBinding(),
    ),
  ];
}
