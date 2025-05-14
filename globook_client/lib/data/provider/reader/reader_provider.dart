import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/reader.dart';

abstract class ReaderProvider {
  Future<ResponseWrapper<ReaderResponse>> getTTSMDTextFirst(
      bool isFile, int fileId, int index);
  Future<ResponseWrapper<ReaderResponse>> getTTSMDTextBefore(
      bool isFile, int fileId, int index);
  Future<ResponseWrapper<ReaderResponse>> getTTSMDTextAfter(
      bool isFile, int fileId, int index);
}
