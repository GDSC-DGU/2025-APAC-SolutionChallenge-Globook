import 'package:get/get.dart';
import 'package:globook_client/presentation/view_model/genre_books/genre_books_view_model.dart';

class GenreBooksBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GenreBooksViewModel());
  }
}
