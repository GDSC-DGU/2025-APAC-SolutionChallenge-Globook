import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/data/provider/reader/reader_provider.dart';
import 'package:globook_client/domain/model/reader.dart';

class ReaderProviderImpl extends BaseConnect implements ReaderProvider {
  @override
  Future<ResponseWrapper<TTSMDText>> getTTSMDTextFirst(
      String bookId, int index) async {
    return ResponseWrapper(
        success: true,
        data: TTSMDText(index: index, text: 'Hello', voiceFile: 'Hello'));
  }

  @override
  Future<ResponseWrapper<TTSMDText>> getTTSMDTextAfter(
      String bookId, int index) async {
    return ResponseWrapper(
        success: true,
        data: TTSMDText(index: index, text: 'Hello', voiceFile: 'Hello'));
  }

  @override
  Future<ResponseWrapper<TTSMDText>> getTTSMDTextBefore(
      String bookId, int index) async {
    return ResponseWrapper(
        success: true,
        data: TTSMDText(index: index, text: 'Hello', voiceFile: 'Hello'));
  }
}
