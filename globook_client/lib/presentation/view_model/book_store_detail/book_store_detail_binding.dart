import 'package:get/get.dart';
import 'package:globook_client/domain/usecase/book_store_detail/book_store_detail_usecase.dart';
import 'package:globook_client/presentation/view_model/book_store_detail/book_store_detail_view_model.dart';

class BookStoreDeatilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookStoreDetailViewModel>(() => BookStoreDetailViewModel());
    Get.lazyPut<BookStoreDetailUseCase>(() => BookStoreDetailUseCase());
  }
}
