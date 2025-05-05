import 'package:get/get.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/usecase/book_store_detail/book_store_detail_usecase.dart';

class BookStoreDetailViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */

  /* -----------Dependency Injection of UseCase------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  final BookStoreDetailUseCase _bookStoreDetailUseCase =
      Get.find<BookStoreDetailUseCase>();

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final Rx<Book?> _currentBook = Rx<Book?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isBookmarked = false.obs;
  final RxList<Book> _categoryBooks = <Book>[].obs;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  Book? get currentBook => _currentBook.value;
  bool get isLoading => _isLoading.value;
  bool get isBookmarked => _isBookmarked.value;
  List<Book> get categoryBooks => _categoryBooks;

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
      _currentBook.value =
          await _bookStoreDetailUseCase.getBookStoreDetail(bookId);
      await _loadCategoryBooks();
      await _checkBookmarkStatus();
    } catch (e) {
      print('Error loading book detail: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadCategoryBooks() async {
    try {
      _categoryBooks.value = await _bookStoreDetailUseCase.getCategoryBooks();
    } catch (e) {
      print('Error loading category books: $e');
    }
  }

  Future<void> _checkBookmarkStatus() async {
    _isBookmarked.value = false;
  }

  /* ------------------------------------------------------ */
  /* ----------------- Public Methods --------------------- */
  /* ------------------------------------------------------ */
  Future<void> loadBookDetail(String bookId) async {
    await _loadBookDetail(bookId);
  }

  Future<void> toggleBookmark() async {
    await _bookStoreDetailUseCase.addFavoriteBook(currentBook!.id);
  }

  Future<void> downloadBook() async {
    await _bookStoreDetailUseCase.downloadBook(currentBook!.id);
  }

  void onCategoryBookPressed(Book book) {
    Get.toNamed('/book_store_detail', arguments: book.id);
  }

  void onViewAllCategoryBooks() {
    Get.toNamed('/book_store_detail', arguments: _currentBook.value?.category);
  }
}
