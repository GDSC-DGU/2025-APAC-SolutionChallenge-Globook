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
  Future<ReaderResponse> getTTSMDTextFirst(
      bool isFile, int fileId, int index) async {
    final response =
        await _readerProvider.getTTSMDTextFirst(isFile, fileId, index);
    return response.data!;
  }

  @override
  Future<ReaderResponse> getTTSMDTextAfter(
      bool isFile, int fileId, int index) async {
    final response =
        await _readerProvider.getTTSMDTextAfter(isFile, fileId, index);
    return response.data!;
  }

  @override
  Future<ReaderResponse> getTTSMDTextBefore(
      bool isFile, int fileId, int index) async {
    final response =
        await _readerProvider.getTTSMDTextBefore(isFile, fileId, index);
    return response.data!;
  }
}
