import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/presentation/view_model/genre_books/genre_books_view_model.dart';
import 'package:globook_client/presentation/widget/search_field.dart';

class GenreBooksScreen extends BaseScreen<GenreBooksViewModel> {
  const GenreBooksScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchField(
              hintText: '장르 내 도서 검색',
              onChanged: (value) {
                viewModel.searchBooks(value);
              },
            ),
            const SizedBox(height: 32),
            Obx(() => Text(
                  viewModel.genreId,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(height: 16),
            _buildBookGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookGrid() {
    return Obx(() {
      if (viewModel.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (viewModel.books.isEmpty) {
        return const Center(child: Text('도서가 없습니다.'));
      }

      return Container(
        decoration: BoxDecoration(
          color: ColorSystem.light,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: viewModel.books.length,
          itemBuilder: (context, index) {
            final book = viewModel.books[index];
            return GestureDetector(
              onTap: () => viewModel.onBookPressed(book),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(book.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    book.author,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorSystem.lightText,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
