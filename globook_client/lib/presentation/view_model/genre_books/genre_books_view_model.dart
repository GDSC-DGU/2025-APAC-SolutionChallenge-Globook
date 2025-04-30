import 'package:get/get.dart';
import 'package:globook_client/domain/model/book.dart';

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

      // 임시 데이터로 테스트
      _books.value = [
        const Book(
          id: '1',
          title: '1984',
          author: 'George Orwell',
          imageUrl: 'https://example.com/1984.jpg',
          description: 'A dystopian novel by George Orwell.',
          category: 'fiction',
          authorBooks: [],
        ),
        const Book(
          id: '2',
          title: 'Brave New World',
          author: 'Aldous Huxley',
          imageUrl: 'https://example.com/brave-new-world.jpg',
          description: 'A dystopian novel by Aldous Huxley.',
          category: 'fiction',
          authorBooks: [],
        ),
        const Book(
          id: '3',
          title: 'Crime and Punishment',
          author: 'Fyodor Dostoevsky',
          imageUrl: 'https://example.com/crime-and-punishment.jpg',
          description: 'A novel by Fyodor Dostoevsky.',
          category: 'fiction',
          authorBooks: [],
        ),
      ];
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
