import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/presentation/view/book_store/book_store_screen.dart';
import 'package:globook_client/presentation/view/book_store_detail/book_store_detail_screen.dart';
import 'package:globook_client/presentation/view/genre_books/genre_books_screen.dart';
import 'package:globook_client/presentation/view/home/home_screen.dart';
import 'package:globook_client/presentation/view/login/login_screen.dart';
import 'package:globook_client/presentation/view/reader/reader_screen.dart';
import 'package:globook_client/presentation/view/root/root_screen.dart';
import 'package:globook_client/presentation/view/splash/splash_screen.dart';
import 'package:globook_client/presentation/view_model/book_store_detail/book_store_detail_binding.dart';
import 'package:globook_client/presentation/view_model/genre_books/genre_books_binding.dart';
import 'package:globook_client/presentation/view_model/reader/reader_binding.dart';

abstract class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.ROOT,
      page: () => const RootScreen(),
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
  ];
}
