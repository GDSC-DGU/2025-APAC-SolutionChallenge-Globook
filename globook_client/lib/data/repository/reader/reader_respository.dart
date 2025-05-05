import 'package:globook_client/domain/model/reader.dart';

abstract class ReaderRepository {
  Future<TTSMDText> getTTSMDTextFirst(String bookId, int index);
  Future<TTSMDText> getTTSMDTextBefore(String bookId, int index);
  Future<TTSMDText> getTTSMDTextAfter(String bookId, int index);
}
