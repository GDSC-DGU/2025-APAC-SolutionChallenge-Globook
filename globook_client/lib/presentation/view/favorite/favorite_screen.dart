import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/data/factory/storage_factory.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/presentation/view/favorite/widgets/book_cover.dart';
import 'package:globook_client/presentation/view/favorite/widgets/book_information.dart';
import 'package:globook_client/presentation/view/favorite/widgets/heart_button.dart';
import 'package:globook_client/presentation/view_model/favorite/favorite_view_model.dart';
import 'package:globook_client/presentation/widget/book_read_setting_bottom_sheet.dart';
import 'package:globook_client/presentation/widget/book_status_button.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/presentation/widget/styled_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends BaseScreen<FavoriteViewModel> {
  const FavoriteScreen({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Favorite Books'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await StorageFactory.systemProvider.deallocateTokens();
            await _clearSharedPreferences();
            Get.offAllNamed(AppRoutes.LOGIN);
          },
        ),
      ],
    );
  }

  Future<void> _clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: viewModel.favoriteBooks.isEmpty
            ? _buildEmptyState()
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.favoriteBooks.length,
                      itemBuilder: (context, index) {
                        final book = viewModel.favoriteBooks[index];
                        return _buildBookItem(context, book);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_outlined,
            size: 80,
            color: ColorSystem.light,
          ),
          SizedBox(height: 16),
          Text(
            'There is no favorite book',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorSystem.mainText,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add a book you like to your favorite',
            style: TextStyle(
              fontSize: 14,
              color: ColorSystem.lightText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookItem(BuildContext context, Book book) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ColorSystem.light),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          BookCover(book: book),
          const SizedBox(width: 16),
          Expanded(
            child: BookInformation(book: book),
          ),
          HeartButton(book: book),
          const SizedBox(width: 8),
          _readButton(book: book),
        ],
      ),
    );
  }

  Widget _readButton({required Book book}) {
    LogUtil.debug('FavoriteScreen: _readButton - book: ${book.id}');
    return StyledButton(
      backgroundColor: ColorSystem.highlight,
      onPressed: () => Get.toNamed(
        AppRoutes.BOOK_STORE_DETAIL,
        arguments: book.id,
      ),
      icon: const Icon(Icons.chrome_reader_mode_outlined),
      textColor: ColorSystem.white,
      text: 'Read',
      fontSize: 14,
    );
  }
}
