import 'package:get/get.dart';
import 'package:globook_client/domain/model/book.dart';

class BookStoreDetailViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */

  /* -----------Dependency Injection of UseCase------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  // 필요한 UseCase 주입 (예: BookUseCase)

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final Rx<Book?> _currentBook = Rx<Book?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isBookmarked = false.obs;
  final RxList<Book> _authorBooks = <Book>[].obs;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  Book? get currentBook => _currentBook.value;
  bool get isLoading => _isLoading.value;
  bool get isBookmarked => _isBookmarked.value;
  List<Book> get authorBooks => _authorBooks;

  @override
  void onInit() {
    super.onInit();
    _loadBookDetail(Get.parameters['bookId'] ?? '');
  }

  /* ------------------------------------------------------ */
  /* ----------------- Private Methods -------------------- */
  /* ------------------------------------------------------ */
  Future<void> _loadBookDetail(String bookId) async {
    _isLoading.value = true;
    try {
      // TODO: API 호출로 대체
      _currentBook.value = const Book(
        id: '1',
        title: '데미안',
        author: '헤르만 헤세',
        imageUrl: 'assets/books/demian.jpg',
        description:
            '『데미안』은 노벨문학상 수상 작가 헤르만 헤세가 1919년에 에밀 싱클레어라는 가명으로 발표한 소설로, 부모님의 품처럼 온화하고 밝은 세계에만 속해 있던 주인공 싱클레어가 처음으로 어둡고 악한 세계에 발을 들이며 겪는 내면의 갈등과 변화를 그린 작품입니다.',
        category: 'fiction',
      );
      await _loadAuthorBooks();
      await _checkBookmarkStatus();
    } catch (e) {
      print('Error loading book detail: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadAuthorBooks() async {
    try {
      // TODO: API 호출로 대체
      _authorBooks.value = [
        const Book(
          id: '2',
          title: '싯다르타',
          author: '헤르만 헤세',
          imageUrl: 'assets/books/siddhartha.jpg',
          description: '인도의 왕자 싯다르타가 깨달음을 얻기까지의 여정을 담은 소설',
          category: 'fiction',
        ),
        const Book(
          id: '3',
          title: '수레바퀴 아래서',
          author: '헤르만 헤세',
          imageUrl: 'assets/books/beneath_the_wheel.jpg',
          description: '교육 제도에 대한 비판과 개인의 정신적 성장을 그린 소설',
          category: 'fiction',
        ),
      ];
    } catch (e) {
      print('Error loading author books: $e');
    }
  }

  Future<void> _checkBookmarkStatus() async {
    // TODO: 실제 북마크 상태 확인 로직 구현
    _isBookmarked.value = false;
  }

  /* ------------------------------------------------------ */
  /* ----------------- Public Methods --------------------- */
  /* ------------------------------------------------------ */
  Future<void> loadBookDetail(String bookId) async {
    await _loadBookDetail(bookId);
  }

  Future<void> toggleBookmark() async {
    try {
      // TODO: 실제 북마크 토글 로직 구현
      _isBookmarked.value = !_isBookmarked.value;
    } catch (e) {
      print('Error toggling bookmark: $e');
    }
  }

  Future<void> downloadBook() async {
    try {
      // TODO: 실제 다운로드 로직 구현
      print('Downloading book...');
    } catch (e) {
      print('Error downloading book: $e');
    }
  }

  void onAuthorBookPressed(Book book) {
    // TODO: 선택한 책의 상세 페이지로 이동
    print('Selected book: ${book.title}');
  }

  void onViewAllAuthorBooks() {
    // TODO: 작가의 모든 책 목록 페이지로 이동
    print('View all books by ${_currentBook.value?.author}');
  }
}
