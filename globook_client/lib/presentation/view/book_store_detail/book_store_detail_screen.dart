import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/presentation/view_model/book_store_detail/book_store_detail_view_model.dart';
import 'package:globook_client/presentation/widget/category_books.dart';
import 'package:globook_client/presentation/widget/current_book.dart';
import 'package:globook_client/presentation/widget/search_field.dart';
import 'package:globook_client/presentation/widget/styled_button.dart';

class BookStoreDetailScreen extends BaseScreen<BookStoreDetailViewModel> {
  const BookStoreDetailScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Obx(() {
      if (viewModel.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (viewModel.currentBook == null) {
        return const Center(child: Text('Book not found'));
      }

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchField(
                hintText: 'Search for your favorite book',
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              CurrentBook(
                imageUrl: viewModel.currentBook!.imageUrl,
                title: viewModel.currentBook!.title,
                author: viewModel.currentBook!.author,
                progress: 0.5,
              ),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 32),
              _buildBookDescription(),
              CategoryBooks(
                title: '${viewModel.currentBook!.author}와 비슷한 도서',
                books: viewModel.categoryBooks,
                onViewAllPressed: viewModel.onViewAllCategoryBooks,
                onBookPressed: viewModel.onCategoryBookPressed,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        StyledButton(
          onPressed: viewModel.downloadBook,
          icon: const Icon(Icons.file_download_outlined,
              color: ColorSystem.mainText),
          backgroundColor: ColorSystem.light,
          textColor: ColorSystem.mainText,
          text: 'Download',
          fontSize: 14,
        ),
        const SizedBox(width: 14),
        StyledButton(
          onPressed: viewModel.toggleBookmark,
          icon: const Icon(Icons.favorite_border, color: ColorSystem.mainText),
          backgroundColor: ColorSystem.light,
          textColor: ColorSystem.mainText,
          text: 'Add to favorites',
          fontSize: 14,
        ),
      ],
    );
  }

  Widget _buildBookDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          viewModel.currentBook!.description,
          style: Get.textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
