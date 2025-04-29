import 'dart:convert';
import 'dart:core';
import 'package:get/get.dart';

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

    // Dependency Injection
  }

  void changeIndex(int index) async {
    _selectedBottomNavigationIndex.value = index;
  }

  @override
  void onReady() async {}
}
