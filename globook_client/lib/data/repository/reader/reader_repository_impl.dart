import 'package:get/get.dart';
import 'package:globook_client/data/provider/reader/reader_provider.dart';
import 'package:globook_client/data/repository/reader/reader_respository.dart';
import 'package:globook_client/domain/model/reader.dart';

class ReaderRepositoryImpl extends GetxService implements ReaderRepository {
  late final ReaderProvider _readerProvider;

  @override
  void onInit() {
    super.onInit();
    _readerProvider = Get.find<ReaderProvider>();
  }

  @override
  Future<TTSMDText> getTTSMDTextFirst(String bookId, int index) async {
    final response = await _readerProvider.getTTSMDTextFirst(bookId, index);
    return response.data!;
  }

  @override
  Future<TTSMDText> getTTSMDTextAfter(String bookId, int index) async {
    final response = await _readerProvider.getTTSMDTextAfter(bookId, index);
    return response.data!;
  }

  @override
  Future<TTSMDText> getTTSMDTextBefore(String bookId, int index) async {
    final response = await _readerProvider.getTTSMDTextBefore(bookId, index);
    return response.data!;
  }
}
