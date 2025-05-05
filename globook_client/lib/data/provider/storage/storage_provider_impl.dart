import 'package:get/get.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/data/provider/storage/storage_provider.dart';
import 'package:globook_client/domain/enum/Efile.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/file.dart';

class StorageProviderImpl extends GetxService implements StorageProvider {
  @override
  Future<ResponseWrapper<List<UserFile>>> getUserFiles() async {
    return ResponseWrapper(data: [
      UserFile(
        id: '1',
        name: 'Policy.pdf',
        previewUrl: 'https://example.com/preview1.jpg',
        fileUrl: 'https://example.com/file1.pdf',
        fileType: FileType.pdf,
        uploadedAt: DateTime.now(),
        status: FileStatus.uploading,
      ),
      UserFile(
        id: '2',
        name: 'Terms.pdf',
        previewUrl: 'https://example.com/preview2.jpg',
        fileUrl: 'https://example.com/file2.pdf',
        fileType: FileType.pdf,
        uploadedAt: DateTime.now(),
        status: FileStatus.translating,
      ),
      UserFile(
        id: '3',
        name: 'Privacy.pdf',
        previewUrl: 'https://example.com/preview3.jpg',
        fileUrl: 'https://example.com/file3.pdf',
        fileType: FileType.pdf,
        uploadedAt: DateTime.now(),
        status: FileStatus.completed,
      ),
    ], success: true);
  }

  @override
  Future<ResponseWrapper<List<Book>>> getUserBooks() async {
    return ResponseWrapper(data: [
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
    ], success: true);
  }
}
