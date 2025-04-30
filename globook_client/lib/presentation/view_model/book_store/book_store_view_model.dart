import 'package:get/get.dart';
import 'package:globook_client/domain/model/book.dart';

class BookStoreViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */
  // 필요한 경우 정적 필드 추가

  /* -----------Dependency Injection of UseCase------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  // 필요한 UseCase 주입 (예: BookUseCase)

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxList<Book> _todayBooks = <Book>[].obs;
  final RxList<Book> _nonFictionBooks = <Book>[].obs;
  final RxList<Book> _philosophyBooks = <Book>[].obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _isLoading = false.obs;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  List<Book> get todayBooks => _todayBooks;
  List<Book> get nonFictionBooks => _nonFictionBooks;
  List<Book> get philosophyBooks => _philosophyBooks;
  String get searchQuery => _searchQuery.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  /* ------------------------------------------------------ */
  /* ----------------- Private Methods -------------------- */
  /* ------------------------------------------------------ */
  Future<void> _loadInitialData() async {
    _isLoading.value = true;
    try {
      await _loadTodayBooks();
      await _loadNonFictionBooks();
      await _loadPhilosophyBooks();
    } catch (e) {
      // TODO: 에러 처리
      print('Error loading books: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadTodayBooks() async {
    // TODO: API 호출로 대체
    _todayBooks.addAll([
      const Book(
        id: '1',
        title: 'Beneath the Wheel',
        author: '헤르만 헤세',
        imageUrl: 'assets/books/beneath_the_wheel.jpg',
        description: '헤르만 헤세의 대표작',
        category: 'fiction',
      ),
      const Book(
        id: '2',
        title: 'Crime and Punishment',
        author: '표도르 도스토예프스키',
        imageUrl: 'assets/books/crime_and_punishment.jpg',
        description: '도스토예프스키의 대표작',
        category: 'fiction',
      ),
      const Book(
        id: '3',
        title: 'Foster',
        author: 'Claire Keegan',
        imageUrl: 'assets/books/foster.jpg',
        description: 'A thing of finely honed beauty',
        category: 'fiction',
      ),
    ]);
  }

  Future<void> _loadNonFictionBooks() async {
    // TODO: API 호출로 대체
    _nonFictionBooks.addAll([
      const Book(
        id: '4',
        title: '1984',
        author: 'George Orwell',
        imageUrl: 'assets/books/1984.jpg',
        description: '조지 오웰의 디스토피아 소설',
        category: 'non-fiction',
      ),
      const Book(
        id: '5',
        title: 'Brave New World',
        author: 'Aldous Huxley',
        imageUrl: 'assets/books/brave_new_world.jpg',
        description: '올더스 헉슬리의 대표작',
        category: 'non-fiction',
      ),
    ]);
  }

  Future<void> _loadPhilosophyBooks() async {
    // TODO: API 호출로 대체
    _philosophyBooks.addAll([
      const Book(
        id: '6',
        title: 'The Boy in the Striped Pyjamas',
        author: 'John Boyne',
        imageUrl: 'assets/books/the_boy.jpg',
        description: '존 보인의 대표작',
        category: 'philosophy',
      ),
      const Book(
        id: '7',
        title: 'Foster',
        author: 'Claire Keegan',
        imageUrl: 'assets/books/foster.jpg',
        description: 'A small miracle',
        category: 'philosophy',
      ),
    ]);
  }

  /* ------------------------------------------------------ */
  /* ----------------- Public Methods --------------------- */
  /* ------------------------------------------------------ */
  void searchBooks(String query) {
    _searchQuery.value = query;
    // TODO: 검색 기능 구현
    print('Searching for: $query');
  }

  Future<void> refreshBooks() async {
    _todayBooks.clear();
    _nonFictionBooks.clear();
    _philosophyBooks.clear();
    await _loadInitialData();
  }
}
