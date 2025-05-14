import 'package:get/get.dart';
import 'package:globook_client/core/usecase/base_usecase.dart';

import 'package:globook_client/data/repository/reader/reader_respository.dart';
import 'package:globook_client/domain/model/reader.dart';

class ReaderUseCase extends BaseUseCase implements ReaderRepository {
  late final ReaderRepository _readerRepository;

  @override
  void onInit() {
    super.onInit();
    _readerRepository = Get.find<ReaderRepository>();
  }

  @override
  Future<ReaderResponse> getTTSMDTextAfter(
      bool isFile, int fileId, int index) async {
    return await _readerRepository.getTTSMDTextAfter(isFile, fileId, index);
  }

  @override
  Future<ReaderResponse> getTTSMDTextBefore(
      bool isFile, int fileId, int index) async {
    return await _readerRepository.getTTSMDTextBefore(isFile, fileId, index);
  }

  @override
  Future<ReaderResponse> getTTSMDTextFirst(
      bool isFile, int fileId, int index) async {
    return await _readerRepository.getTTSMDTextFirst(isFile, fileId, index);
  }
}
