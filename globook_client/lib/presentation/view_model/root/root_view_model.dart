import 'dart:convert';
import 'dart:core';
import 'package:get/get.dart';
import 'package:globook_client/presentation/view_model/home/home_view_model.dart';

class RootViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */

  /* -----------Dependeny Injection of UseCase------------- */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  late final RxInt _selectedBottomNavigationIndex = RxInt(2);

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  // DateTime get currentAt => _currentAt.value;
  int get selectedIndex => _selectedBottomNavigationIndex.value;

  @override
  void onInit() async {
    super.onInit();

    // 초기 화면을 Home으로 설정
    _selectedBottomNavigationIndex.value = 2;
  }

  void changeIndex(int index) async {
    _selectedBottomNavigationIndex.value = index;
  }

  @override
  void onReady() async {}
}
