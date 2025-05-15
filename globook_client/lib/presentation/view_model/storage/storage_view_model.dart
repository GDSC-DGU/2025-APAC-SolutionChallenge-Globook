import 'package:get/get.dart';
import 'package:globook_client/domain/enum/Efile.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/file.dart';
import 'package:globook_client/domain/usecase/storage/storage_usecase.dart';

class StorageViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */

  /* -----------Dependency Injection of UseCase------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final StorageUsecase _storageUseCase;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxList<UserFile> _myFiles = RxList<UserFile>();
  final RxList<Book> _books = RxList<Book>();
  final RxBool _isLoading = RxBool(false);

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  List<UserFile> get myFiles => _myFiles;
  List<Book> get books => _books;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _storageUseCase = Get.find<StorageUsecase>();
    loadData();
  }

  void loadData() async {
    _isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // 임시 딜레이

      // 임시 파일 데이터
      _myFiles.value = await _storageUseCase.getUserFiles();

      // 임시 도서 데이터
      _books.value = await _storageUseCase.getUserBooks();
    } catch (e) {
      print('Error loading archive data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void onFilePressed(UserFile file) {
    // TODO: 파일 상세 보기 구현
  }

  void onBookPressed(Book book) {
    Get.toNamed('/book-store-detail/${book.id}');
  }

  void readFile(int fileId, int index, String type) {
    Get.toNamed('/reader/${fileId}/${index}/$type');
  }

  void readBook(int bookId) {
    Get.toNamed('/reader/${bookId}/0/BOOK');
  }

  void viewAllFiles() {
    // TODO: 전체 파일 목록 보기 구현
  }

  void viewAllBooks() {
    // TODO: 전체 도서 목록 보기 구현
  }
}
