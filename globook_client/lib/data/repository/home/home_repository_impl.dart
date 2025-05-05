import 'package:get/get.dart';
import 'package:globook_client/data/provider/home/home_provider.dart';
import 'package:globook_client/data/repository/home/home_repository.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/app/utility/log_util.dart';

class HomeRepositoryImpl extends GetxService implements HomeRepository {
  late final HomeProvider _homeProvider;

  @override
  void onInit() {
    super.onInit();
    _homeProvider = Get.find<HomeProvider>();
  }

  @override
  Future<Book> getLastReadBook() async {
    final response = await _homeProvider.getLastReadBook();
    return response.data!;
  }

  @override
  Future<List<Book>> getLibraryBooks() async {
    final response = await _homeProvider.getLibraryBooks();
    return response.data!;
  }
}
