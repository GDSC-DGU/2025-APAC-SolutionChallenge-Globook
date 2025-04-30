import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/presentation/view_model/book_store/book_store_view_model.dart';
import 'package:globook_client/presentation/widget/search_field.dart';
import 'package:globook_client/presentation/widget/category_books.dart';
import 'package:globook_client/presentation/view/book_store/widget/featured_books_carousel.dart';

class BookStoreScreen extends BaseScreen<BookStoreViewModel> {
  const BookStoreScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SearchField(
                hintText: 'Search for your favorite book',
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
                  _buildNonFictionSection(),
                  const SizedBox(height: 32),
                  _buildPhilosophySection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayBooks() {
    return FeaturedBooksCarousel(
      title: "Today's Book",
      books: viewModel.todayBooks,
      onBookPressed: (book) {
        // TODO: Navigate to book detail
        Get.toNamed(AppRoutes.BOOK_STORE_DETAIL, arguments: book.id);
      },
      onViewAllPressed: () {
        // TODO: Navigate to all today's books
      },
    );
  }

  Widget _buildNonFictionSection() {
    return CategoryBooks(
      title: 'Non-Fiction',
      books: viewModel.nonFictionBooks,
      onViewAllPressed: () {
        Get.toNamed(AppRoutes.GENRE_BOOKS, arguments: 'non-fiction');
      },
      onBookPressed: (book) {
        // TODO: Navigate to book detail
        Get.toNamed(AppRoutes.BOOK_STORE_DETAIL, arguments: book.id);
      },
    );
  }

  Widget _buildPhilosophySection() {
    return CategoryBooks(
      title: 'Philosophy',
      books: viewModel.philosophyBooks,
      onViewAllPressed: () {
        // TODO: Navigate to philosophy category
        Get.toNamed(AppRoutes.GENRE_BOOKS, arguments: 'philosophy');
      },
      onBookPressed: (book) {
        // TODO: Navigate to book detail
        Get.toNamed(AppRoutes.BOOK_STORE_DETAIL, arguments: book.id);
      },
    );
  }
}
