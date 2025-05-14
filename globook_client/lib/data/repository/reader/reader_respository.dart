import 'package:globook_client/domain/model/reader.dart';

abstract class ReaderRepository {
  Future<ReaderResponse> getTTSMDTextFirst(bool isFile, int fileId, int index);
  Future<ReaderResponse> getTTSMDTextBefore(bool isFile, int fileId, int index);
  Future<ReaderResponse> getTTSMDTextAfter(bool isFile, int fileId, int index);
}
