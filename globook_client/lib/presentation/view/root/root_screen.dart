import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/presentation/view/book_store/book_store_screen.dart';
import 'package:globook_client/presentation/view/favorite/favorite_screen.dart';
import 'package:globook_client/presentation/view/home/home_screen.dart';
import 'package:globook_client/presentation/view/storage/storage_screen.dart';
import 'package:globook_client/presentation/view/upload/upload_screen.dart';
import 'package:globook_client/presentation/view_model/root/root_view_model.dart';

class RootScreen extends BaseScreen<RootViewModel> {
  const RootScreen({super.key});

  // 화면 목록
  final List<Widget> screens = const [
    Center(child: UploadScreen()),
    Center(child: StorageScreen()),
    Center(child: HomeScreen()),
    Center(child: BookStoreScreen()),
    Center(child: FavoriteScreen()),
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
              label: 'Upload',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined),
              label: 'Storage',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Book Store',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
          ],
        ));
  }
}
