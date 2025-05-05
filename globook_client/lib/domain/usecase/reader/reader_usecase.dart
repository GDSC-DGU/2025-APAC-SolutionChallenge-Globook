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
  Future<TTSMDText> getTTSMDTextAfter(String bookId, int index) async {
    return await _readerRepository.getTTSMDTextAfter(bookId, index);
  }

  @override
  Future<TTSMDText> getTTSMDTextBefore(String bookId, int index) async {
    return await _readerRepository.getTTSMDTextBefore(bookId, index);
  }

  @override
  Future<TTSMDText> getTTSMDTextFirst(String bookId, int index) async {
    return await _readerRepository.getTTSMDTextFirst(bookId, index);
  }
}
