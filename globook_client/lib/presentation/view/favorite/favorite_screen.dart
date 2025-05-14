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
import 'package:globook_client/presentation/widget/book_read_setting_bottom_sheet.dart';
import 'package:globook_client/presentation/widget/book_status_button.dart';
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
        child: Column(
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
          BookStatusButton(
            context: context,
            status: book.downloadStatus,
            showDownloadBottomSheet: () {
              _showDownloadBottomSheet(context, book);
            },
          ),
        ],
      ),
    );
  }

  void _showDownloadBottomSheet(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.7,
        minChildSize: 0.3,
        initialChildSize: 0.5,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: BookReadSettingBottomSheet(
            isFromUpload: false,
            bookId: book.id,
          ),
        ),
      ),
    );
  }
}
