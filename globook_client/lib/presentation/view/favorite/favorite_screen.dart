import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/data/factory/storage_factory.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/presentation/view/favorite/widgets/book_cover.dart';
import 'package:globook_client/presentation/view/favorite/widgets/book_information.dart';
import 'package:globook_client/presentation/view/favorite/widgets/heart_button.dart';
import 'package:globook_client/presentation/view_model/favorite/favorite_view_model.dart';
import 'package:globook_client/presentation/widget/styled_button.dart';
import 'package:globook_client/app/config/app_routes.dart';

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
            Get.offAllNamed(AppRoutes.LOGIN);
          },
        ),
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: _buildBookList(),
      ),
    );
  }

  Widget _buildBookList() {
    return Expanded(
      child: ListView.builder(
        itemCount: viewModel.favoriteBooks.length,
        itemBuilder: (context, index) {
          final book = viewModel.favoriteBooks[index];
          return _buildBookItem(book);
        },
      ),
    );
  }

  Widget _buildBookItem(Book book) {
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
          StyledButton(
            width: 64,
            height: 28,
            onPressed: () {
              viewModel.readBook(book.id);
            },
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.library_books_rounded,
              size: 13,
            ),
            text: 'read',
            fontSize: 12,
            backgroundColor: ColorSystem.highlight,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
