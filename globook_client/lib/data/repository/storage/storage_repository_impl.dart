import 'package:get/get.dart';
import 'package:globook_client/data/provider/storage/storage_provider.dart';
import 'package:globook_client/data/repository/storage/storage_repository.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/file.dart';

class StorageRepositoryImpl extends GetxService implements StorageRepository {
  late final StorageProvider _storageProvider;

  @override
  void onInit() {
    super.onInit();
    _storageProvider = Get.find<StorageProvider>();
  }

  @override
  Future<List<UserFile>> getUserFiles() async {
    final response = await _storageProvider.getUserFiles();
    return response.data ?? [];
  }

  @override
  Future<List<Book>> getUserBooks() async {
    final response = await _storageProvider.getUserBooks();
    return response.data ?? [];
  }

  @override
  Future<void> readFile(int fileId, int index) async {
    final response = await _storageProvider.readFile(fileId, index);
    return response.data;
  }
}
