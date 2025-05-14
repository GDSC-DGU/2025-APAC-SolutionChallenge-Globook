// lib/presentation/view_model/home/home_view_model.dart
import 'dart:core';
import 'package:get/get.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/reader.dart';
import 'package:globook_client/domain/usecase/home/home_usecase.dart';

class HomeViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */

  /* -----------Dependency Injection of UseCase------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  // 필요한 UseCase 주입 (예: BookUseCase)
  late final HomeUseCase _homeUseCase;
  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxBool _isLoading = false.obs;

  late final Rx<ParagraphsInfo> _currentParagraphsInfo =
      Rx<ParagraphsInfo>(ParagraphsInfo(
    id: 0,
    title: '',
    targetLanguage: '',
    persona: '',
    maxIndex: 0,
    currentIndex: 0,
    imageUrl: '',
  ));

  final RxList<Book> _anotherBooks = RxList<Book>([]);

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  bool get isLoading => _isLoading.value;
  ParagraphsInfo get currentParagraphsInfo => _currentParagraphsInfo.value;
  List<Book> get anotherBooks => _anotherBooks;

  @override
  void onInit() async {
    super.onInit();

    // Dependency Injection
    _homeUseCase = Get.find<HomeUseCase>();

    // Initialize Data
    await loadBooks();
  }

  Future<void> loadBooks() async {
    _isLoading.value = true;
    try {
      final lastParagraphsInfo = await _homeUseCase.getLastParagraphsInfo();
      final libraryBooks = await _homeUseCase.getLibraryBooks();
      LogUtil.debug('[loadBooks]asdlastParagraphsInfo: $lastParagraphsInfo');
      _currentParagraphsInfo.value = lastParagraphsInfo;
      _anotherBooks.value = libraryBooks;
    } catch (e) {
      LogUtil.error('Error loading books: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void continueReading(int fileId, int index, String type) {
    // 책 읽기 화면으로 이동하는 로직
    LogUtil.debug(
        '[continueReading]fileId: $fileId, index: $index, type: $type');
    Get.toNamed(
      '/reader/$fileId/$index/$type',
    );
  }

  @override
  void onReady() async {}
}
