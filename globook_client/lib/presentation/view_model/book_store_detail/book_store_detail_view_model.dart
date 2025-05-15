import 'dart:async';
import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/domain/enum/EbookDownloadStatus.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/usecase/book_store_detail/book_store_detail_usecase.dart';
import 'package:globook_client/presentation/view_model/favorite/favorite_view_model.dart';
import 'package:globook_client/presentation/view_model/storage/storage_view_model.dart';

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
  final Rx<EbookDownloadStatus?> _downloadStatus =
      Rx<EbookDownloadStatus?>(null);
  final RxBool _isFavorite = false.obs;
  final RxList<Book> _categoryBooks = <Book>[].obs;
  Timer? _statusCheckTimer;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  Book? get currentBook => _currentBook.value;
  bool get isLoading => _isLoading.value;
  EbookDownloadStatus? get downloadStatus => _downloadStatus.value;
  bool get isFavorite => _isFavorite.value;
  List<Book> get categoryBooks => _categoryBooks;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is int) {
      _loadBookDetail(arguments);
    }
  }

  @override
  void onClose() {
    _statusCheckTimer?.cancel();
    super.onClose();
  }

  /* ------------------------------------------------------ */
  /* ----------------- Private Methods -------------------- */
  /* ------------------------------------------------------ */
  Future<void> _loadBookDetail(int bookId) async {
    if (bookId <= 0) {
      print('Invalid book ID: $bookId');
      return;
    }

    // 이전 상태 초기화
    _currentBook.value = null;
    _downloadStatus.value = null;
    _isFavorite.value = false;
    _categoryBooks.clear();
    _statusCheckTimer?.cancel();

    _isLoading.value = true;
    try {
      final book = await _bookStoreDetailUseCase.getBookStoreDetail(bookId);
      _currentBook.value = book;
      await _checkStatus();
      await _loadCategoryBooks();
    } catch (e) {
      print('Error loading book detail: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadCategoryBooks() async {
    final otherBookList = currentBook?.otherBookList;
    if (otherBookList != null) {
      _categoryBooks.value = otherBookList;
    }
  }

  Future<void> _checkStatus() async {
    _isFavorite.value = currentBook?.isFavorite ?? false;

    // 서버에서 받아온 상태 확인
    final status = currentBook?.downloadStatus;
    if (status == null) {
      _downloadStatus.value = EbookDownloadStatus.download;
    } else {
      _downloadStatus.value = status;
    }

    // 다운로드 중이면 타이머 시작
    if (_downloadStatus.value == EbookDownloadStatus.downloading) {
      _startStatusCheckTimer();
    } else {
      _statusCheckTimer?.cancel();
    }

    LogUtil.debug(
        'BookStoreDetailViewModel: _checkStatus - status: ${_downloadStatus.value}');
  }

  void _startStatusCheckTimer() {
    _statusCheckTimer?.cancel();
    _statusCheckTimer =
        Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_currentBook.value != null) {
        try {
          final book = await _bookStoreDetailUseCase
              .getBookStoreDetail(_currentBook.value!.id);
          if (book.downloadStatus != _downloadStatus.value) {
            _downloadStatus.value = book.downloadStatus;
            if (book.downloadStatus != EbookDownloadStatus.downloading) {
              _statusCheckTimer?.cancel();
            }
          }
        } catch (e) {
          print('Error checking download status: $e');
        }
      }
    });
  }

  /* ------------------------------------------------------ */
  /* ----------------- Public Methods --------------------- */
  /* ------------------------------------------------------ */
  Future<void> loadBookDetail(int bookId) async {
    await _loadBookDetail(bookId);
  }

  Future<void> toggleFavorite(bool isFavorite) async {
    final favoriteViewModel = Get.find<FavoriteViewModel>();

    if (isFavorite) {
      final isSuccess =
          await _bookStoreDetailUseCase.removeFavoriteBook(currentBook!.id);
      if (isSuccess) {
        _isFavorite.value = !_isFavorite.value;
      }
    } else {
      final isSuccess =
          await _bookStoreDetailUseCase.addFavoriteBook(currentBook!.id);
      if (isSuccess) {
        _isFavorite.value = !_isFavorite.value;
      }
    }
    favoriteViewModel.loadBooks();
  }

  Future<void> downloadBook(int bookId, String language, String persona) async {
    try {
      // 즉시 상태를 downloading으로 변경
      _downloadStatus.value = EbookDownloadStatus.downloading;
      _startStatusCheckTimer();

      final isSuccess =
          await _bookStoreDetailUseCase.downloadBook(bookId, language, persona);
      if (!isSuccess) {
        _downloadStatus.value = EbookDownloadStatus.download;
      } else {
        _downloadStatus.value = EbookDownloadStatus.read;
        Get.find<StorageViewModel>().loadData();
      }
      _statusCheckTimer?.cancel();
    } catch (e) {
      _downloadStatus.value = EbookDownloadStatus.download;
      _statusCheckTimer?.cancel();
      print('Error downloading book: $e');
    }
  }

  void onCategoryBookPressed(Book book) {
    LogUtil.info('onCategoryBookPressed: ${book.id}');
    _loadBookDetail(book.id);
  }

  void onViewAllCategoryBooks() {
    if (_currentBook.value?.category != null) {
      Get.toNamed(AppRoutes.GENRE_BOOKS,
          arguments: _currentBook.value!.category.toString().split('.').last);
    }
  }
}
