import 'package:get/get.dart';
import 'package:globook_client/domain/usecase/reader/reader_usecase.dart';
import 'package:globook_client/presentation/view_model/reader/reader_view_model.dart';

class ReaderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReaderViewModel>(() => ReaderViewModel());
    Get.lazyPut<ReaderUseCase>(() => ReaderUseCase());
  }
}
