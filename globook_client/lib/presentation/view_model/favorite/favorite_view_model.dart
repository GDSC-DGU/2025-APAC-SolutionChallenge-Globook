// lib/presentation/view_model/upload/upload_view_model.dart
import 'dart:core';
import 'dart:async';
import 'package:get/get.dart';
import 'package:globook_client/domain/enum/EbookDownloadStatus.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/usecase/favorite/favorite_usecase.dart';

class FavoriteViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */

  /* -----------Dependency Injection of UseCase------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final FavoriteUseCase _favoriteUseCase;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxList<Book> _favoriteBooks = RxList<Book>();
  final RxString _searchQuery = RxString('');
  Timer? _statusUpdateTimer;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  List<Book> get favoriteBooks => _favoriteBooks;
  String get searchQuery => _searchQuery.value;

  @override
  void onInit() async {
    super.onInit();
    // Dependency Injection
    _favoriteUseCase = Get.find<FavoriteUseCase>();

    // 초기 데이터 로드
    loadBooks();
  }

  void loadBooks() async {
    // 즐겨찾기 도서 데이터 로드
    final response = await _favoriteUseCase.getFavoriteBooks();
    _favoriteBooks.value = response;
  }

  void searchFiles(String query) {
    if (query.isEmpty) {
      loadBooks();
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final filteredBooks = _favoriteBooks
        .where((book) => book.title.toLowerCase().contains(lowercaseQuery))
        .toList();

    _favoriteBooks.value = filteredBooks;
  }

  Future<void> removeFavoriteBook(int bookId) async {
    await _favoriteUseCase.removeFavoriteBook(bookId);
    loadBooks();
  }

  Future<void> readBook(int bookId) async {
    await _favoriteUseCase.readBook(bookId);
    loadBooks();
  }
}
