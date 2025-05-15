import 'package:get/get.dart';
import 'package:globook_client/domain/enum/EbookCategory.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/presentation/view_model/book_store/book_store_view_model.dart';

class GenreBooksViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */

  /* -----------Dependeny Injection of UseCase------------- */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxString _genreId = RxString('');
  final RxList<Book> _books = RxList<Book>();
  final RxBool _isLoading = RxBool(false);

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  String get genreId => _genreId.value;
  List<Book> get books => _books;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();

    // URL 파라미터에서 genreId를 가져옵니다
    final String? paramGenreId = Get.parameters['genreId'];
    if (paramGenreId != null) {
      _genreId.value = paramGenreId;
    }

    // arguments에서 장르 이름을 가져옵니다
    final dynamic arguments = Get.arguments;
    if (arguments != null) {
      _genreId.value = arguments;
    }

    // 초기 데이터 로드
    loadBooks();
  }

  void loadBooks() async {
    _isLoading.value = true;
    try {
      // TODO: API 호출로 해당 장르의 도서 목록을 가져옵니다
      await Future.delayed(const Duration(milliseconds: 500)); // 임시 딜레이
      Get.find<BookStoreViewModel>().getBooksByCategory(EbookCategory.MYSTERY);
    } catch (e) {
      print('Error loading books: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void searchBooks(String query) {
    if (query.isEmpty) {
      loadBooks();
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final filteredBooks = _books
        .where((book) =>
            book.title.toLowerCase().contains(lowercaseQuery) ||
            book.author.toLowerCase().contains(lowercaseQuery))
        .toList();

    _books.value = filteredBooks;
  }

  void onBookPressed(Book book) {
    Get.toNamed('/book-store-detail/${book.id}');
  }
}
