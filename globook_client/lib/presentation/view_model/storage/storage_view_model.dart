import 'package:get/get.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/file.dart';

class StorageViewModel extends GetxController {
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
    loadData();
  }

  void loadData() async {
    _isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // 임시 딜레이

      // 임시 파일 데이터
      _myFiles.value = [
        UserFile(
          id: '1',
          name: 'Policy.pdf',
          previewUrl: 'https://example.com/preview1.jpg',
          fileUrl: 'https://example.com/file1.pdf',
          fileType: FileType.pdf,
          uploadedAt: DateTime.now(),
          status: FileStatus.completed,
        ),
        UserFile(
          id: '2',
          name: 'Terms.pdf',
          previewUrl: 'https://example.com/preview2.jpg',
          fileUrl: 'https://example.com/file2.pdf',
          fileType: FileType.pdf,
          uploadedAt: DateTime.now(),
          status: FileStatus.uploading,
        ),
        UserFile(
          id: '3',
          name: 'Privacy.pdf',
          previewUrl: 'https://example.com/preview3.jpg',
          fileUrl: 'https://example.com/file3.pdf',
          fileType: FileType.pdf,
          uploadedAt: DateTime.now(),
          status: FileStatus.translating,
        ),
      ];

      // 임시 도서 데이터
      _books.value = [
        const Book(
          id: '1',
          title: 'Beyond the Wind',
          author: 'John Smith',
          imageUrl: 'https://example.com/book1.jpg',
          description: 'A story about adventure.',
          category: 'fiction',
          authorBooks: [],
        ),
        const Book(
          id: '2',
          title: 'Crime and Punishment',
          author: 'Fyodor Dostoevsky',
          imageUrl: 'https://example.com/book2.jpg',
          description: 'A psychological thriller.',
          category: 'fiction',
          authorBooks: [],
        ),
        const Book(
          id: '3',
          title: 'Foster',
          author: 'Claire Keegan',
          imageUrl: 'https://example.com/book3.jpg',
          description: 'A touching story.',
          category: 'fiction',
          authorBooks: [],
        ),
      ];
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

  void viewAllFiles() {
    // TODO: 전체 파일 목록 보기 구현
  }

  void viewAllBooks() {
    // TODO: 전체 도서 목록 보기 구현
  }
}
