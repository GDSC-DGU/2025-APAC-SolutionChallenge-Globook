import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/domain/enum/EbookDownloadStatus.dart';
import 'package:globook_client/presentation/view_model/book_store_detail/book_store_detail_view_model.dart';
import 'package:globook_client/presentation/widget/book_status_button.dart';
import 'package:globook_client/presentation/widget/category_books.dart';
import 'package:globook_client/presentation/widget/current_book.dart';
import 'package:globook_client/presentation/widget/styled_button.dart';
import 'package:globook_client/presentation/widget/book_read_setting_bottom_sheet.dart';

class BookStoreDetailScreen extends BaseScreen<BookStoreDetailViewModel> {
  const BookStoreDetailScreen({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ColorSystem.light,
      title: Obx(() => Text(viewModel.currentBook?.title ?? 'Loading...')),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Obx(() {
      if (viewModel.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CurrentBook(
                imageUrl: viewModel.currentBook!.imageUrl,
                title: viewModel.currentBook!.title,
                author: viewModel.currentBook!.author,
              ),
              const SizedBox(height: 24),
              _buildActionButtons(
                context,
                viewModel.downloadStatus,
                viewModel.isFavorite,
              ),
              const SizedBox(height: 32),
              _buildBookDescription(),
              CategoryBooks(
                title: '${viewModel.currentBook!.title}와 비슷한 도서',
                books: viewModel.categoryBooks,
                onViewAllPressed: () {
                  Get.toNamed(AppRoutes.GENRE_BOOKS,
                      arguments: viewModel.currentBook!.category);
                },
                onBookPressed: (book) {
                  viewModel.loadBookDetail(book.id);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActionButtons(BuildContext context,
      EbookDownloadStatus? downloadStatus, bool isFavorite) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: BookStatusButton(
                context: context,
                status: downloadStatus,
                showDownloadBottomSheet: () =>
                    _showDownloadBottomSheet(context))),
        const SizedBox(width: 14),
        Expanded(
          child: _buildFavoriteButton(isFavorite),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(bool isFavorite) {
    return StyledButton(
      onPressed: () => viewModel.toggleFavorite(isFavorite),
      icon: isFavorite
          ? const Icon(Icons.favorite, color: ColorSystem.mainText)
          : const Icon(Icons.favorite_border, color: ColorSystem.mainText),
      text: isFavorite ? 'Remove favorite' : 'Add to favorites',
      textColor: ColorSystem.mainText,
      backgroundColor: ColorSystem.light,
      fontSize: 14,
    );
  }

  void _showDownloadBottomSheet(BuildContext context) {
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
            bookId: viewModel.currentBook!.id,
          ),
        ),
      ),
    );
  }

  Widget _buildBookDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          viewModel.currentBook!.description ?? '',
          style: Get.textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
