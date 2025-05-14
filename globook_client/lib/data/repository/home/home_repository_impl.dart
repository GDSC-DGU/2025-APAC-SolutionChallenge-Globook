import 'package:get/get.dart';
import 'package:globook_client/data/provider/home/home_provider.dart';
import 'package:globook_client/data/repository/home/home_repository.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/reader.dart';
import 'package:globook_client/presentation/view_model/reader/reader_shared_preference.dart';

class HomeRepositoryImpl extends GetxService implements HomeRepository {
  late final HomeProvider _homeProvider;

  @override
  void onInit() {
    super.onInit();
    _homeProvider = Get.find<HomeProvider>();
  }

  @override
  Future<ParagraphsInfo> getLastParagraphsInfo() async {
    final paragraphsInfo =
        await ReaderSharedPreference().loadLastParagraphsInfo();

    return paragraphsInfo ??
        ParagraphsInfo(
          id: -1,
          title: '읽은 책이 없네요!',
          
          targetLanguage: 'EN',
          persona: 'ETHAN',
          maxIndex: 100,
          currentIndex: 0,
          imageUrl: 'https://storage.googleapis.com/globook-bucket/globook.png',
        );
  }

  @override
  Future<List<Book>> getLibraryBooks() async {
    final response = await _homeProvider.getLibraryBooks();
    return response.data!;
  }
}
