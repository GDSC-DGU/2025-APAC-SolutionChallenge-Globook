import 'package:get/get.dart';
import 'package:globook_client/core/usecase/base_usecase.dart';
import 'package:globook_client/data/repository/storage/storage_repository.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/file.dart';

class StorageUsecase extends BaseUseCase implements StorageRepository {
  late final StorageRepository _storageRepository;

  @override
  void onInit() {
    super.onInit();
    _storageRepository = Get.find<StorageRepository>();
  }

  @override
  Future<List<UserFile>> getUserFiles() async {
    return await _storageRepository.getUserFiles();
  }

  @override
  Future<List<Book>> getUserBooks() async {
    return await _storageRepository.getUserBooks();
  }
}
