import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/reader.dart';

abstract class ReaderProvider {
  Future<ResponseWrapper<TTSMDText>> getTTSMDTextFirst(
      String bookId, int index);
  Future<ResponseWrapper<TTSMDText>> getTTSMDTextBefore(
      String bookId, int index);
  Future<ResponseWrapper<TTSMDText>> getTTSMDTextAfter(
      String bookId, int index);
}
