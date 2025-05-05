import 'package:get/get.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/usecase/book_store/book_store_usecase.dart';

class BookStoreViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */

  /* -----------Dependency Injection of UseCase------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final BookStoreUseCase _bookStoreUseCase;
  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxList<Book> _todayBooks = RxList<Book>([]);
  final RxList<Book> _nonFictionBooks = RxList<Book>([]);
  final RxList<Book> _philosophyBooks = RxList<Book>([]);
  final RxString _searchQuery = ''.obs;
  final RxBool _isLoading = false.obs;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  // ignore: invalid_use_of_protected_member
  List<Book> get todayBooks => _todayBooks.value;
  // ignore: invalid_use_of_protected_member
  List<Book> get nonFictionBooks => _nonFictionBooks.value;
  // ignore: invalid_use_of_protected_member
  List<Book> get philosophyBooks => _philosophyBooks.value;
  String get searchQuery => _searchQuery.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() async {
    super.onInit();
    _bookStoreUseCase = Get.find<BookStoreUseCase>();
    await _loadInitialData();
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
      print('Error loading books: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadTodayBooks() async {
    _todayBooks.addAll(await _bookStoreUseCase.getTodayBooks());
  }

  Future<void> _loadNonFictionBooks() async {
    _nonFictionBooks.addAll(await _bookStoreUseCase.getNonFictionBooks());
  }

  Future<void> _loadPhilosophyBooks() async {
    _philosophyBooks.addAll(await _bookStoreUseCase.getPhilosophyBooks());
  }

  /* ------------------------------------------------------ */
  /* ----------------- Public Methods --------------------- */
  /* ------------------------------------------------------ */
  void searchBooks(String query) {
    _searchQuery.value = query;
    print('Searching for: $query');
  }

  Future<void> refreshBooks() async {
    _todayBooks.clear();
    _nonFictionBooks.clear();
    _philosophyBooks.clear();
    await _loadInitialData();
  }
}
