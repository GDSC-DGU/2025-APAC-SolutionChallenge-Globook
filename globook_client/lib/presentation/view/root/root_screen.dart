import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/presentation/view/home/home_screen.dart';
import 'package:globook_client/presentation/view/login/login_screen.dart';
import 'package:globook_client/presentation/view/upload/upload_screen.dart';
import 'package:globook_client/presentation/view_model/root/root_view_model.dart';

class RootScreen extends BaseScreen<RootViewModel> {
  const RootScreen({super.key});

  // 화면 목록
  final List<Widget> screens = const [
    Center(child: UploadScreen()),
    Center(child: Text('즐겨찾기')),
    Center(child: HomeScreen()),
    Center(child: Text('업로드')),
    Center(child: LoginScreen()),
  ];

  @override
  Widget buildBody(BuildContext context) {
    return Obx(() => screens[viewModel.selectedIndex]);
  }

  @override
  Widget? buildBottomNavigationBar(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: viewModel.selectedIndex,
          onTap: viewModel.changeIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.upload),
              label: '업로드',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined),
              label: '보관함',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: '서점',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: '즐겨찾기',
            ),
          ],
        ));
  }
}
