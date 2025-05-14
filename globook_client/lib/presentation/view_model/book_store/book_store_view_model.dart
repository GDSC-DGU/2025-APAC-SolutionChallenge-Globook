import 'package:get/get.dart';
import 'package:globook_client/domain/enum/EbookCategory.dart';
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
  final RxMap<EbookCategory, List<Book>> _categorizedBooks =
      <EbookCategory, List<Book>>{}.obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _isLoading = false.obs;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  // ignore: invalid_use_of_protected_member
  List<Book> get todayBooks => _todayBooks.value;
  List<Book> getBooksByCategory(EbookCategory category) =>
      _categorizedBooks[category] ?? [];
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
      await _loadAllCategoryBooks();
    } catch (e) {
      print('Error loading books: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadTodayBooks() async {
    final response = await _bookStoreUseCase.getTodayBooks('COMPUTER');
    _todayBooks.value = response;
  }

  Future<void> _loadAllCategoryBooks() async {
    final response = await _bookStoreUseCase.getAllCategoryBooks();
    _categorizedBooks.clear();

    response.forEach((category, books) {
      final ebookCategory = EbookCategory.values.firstWhere(
        (e) => e.toString().split('.').last == category,
        orElse: () => EbookCategory.SCIENCE,
      );
      _categorizedBooks[ebookCategory] = books;
    });
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
    _categorizedBooks.clear();
    await _loadInitialData();
  }
}
