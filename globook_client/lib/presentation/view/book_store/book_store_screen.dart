import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/domain/enum/EbookCategory.dart';
import 'package:globook_client/presentation/view_model/book_store/book_store_view_model.dart';
import 'package:globook_client/presentation/widget/search_field.dart';
import 'package:globook_client/presentation/widget/category_books.dart';
import 'package:globook_client/presentation/view/book_store/widget/featured_books_carousel.dart';

class BookStoreScreen extends BaseScreen<BookStoreViewModel> {
  const BookStoreScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SearchField(
                  hintText: 'Search for your book',
                  onChanged: (value) {
                    viewModel.searchBooks(value);
                  },
                ),
              ),
              const SizedBox(height: 32),
              _buildTodayBooks(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    ...EbookCategory.values.map((category) => Column(
                          children: [
                            _buildCategoryBooks(category),
                            const SizedBox(height: 32),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayBooks() {
    return FeaturedBooksCarousel(
      title: "Today's Book",
      books: viewModel.todayBooks,
      onBookPressed: (book) {
        Get.toNamed(AppRoutes.BOOK_STORE_DETAIL, arguments: book.id);
      },
    );
  }

  Widget _buildCategoryBooks(EbookCategory category) {
    return CategoryBooks(
      title: category.toString().split('.').last,
      books: viewModel.getBooksByCategory(category),
      onBookPressed: (book) {
        Get.toNamed(AppRoutes.BOOK_STORE_DETAIL, arguments: book.id);
      },
      onViewAllPressed: () {
        Get.toNamed(AppRoutes.GENRE_BOOKS,
            arguments: category.toString().split('.').last);
      },
    );
  }
}
