// ignore_for_file: constant_identifier_names

abstract class AppRoutes {
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String ROOT = '/root';
  static const String SPLASH = '/splash';
  static const String HOME = '/home';
  static const String STORAGE = '/storage';
  static const String BOOK_STORE = '/book-store';
  static const String BOOK_STORE_DETAIL = '/book-store-detail/:bookId';
  static const String GENRE_BOOKS = '/genre-books/:genreId';
  static const String READER = '/reader/:fileId/:index/:type';
  static const String FAVORITE = '/favorite';
  static const String UPLOAD = '/upload';
}
