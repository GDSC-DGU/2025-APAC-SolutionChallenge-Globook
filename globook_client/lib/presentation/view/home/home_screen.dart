import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/presentation/view/home/widget/current_book.dart';
import 'package:globook_client/presentation/view/home/widget/language_selector.dart';
import 'package:globook_client/presentation/view/home/widget/recommended_books.dart';
import 'package:globook_client/presentation/view_model/home/home_view_model.dart';
import 'package:globook_client/presentation/widget/styled_button.dart';
import 'package:get/get.dart';

class HomeScreen extends BaseScreen<HomeViewModel> {
  const HomeScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Container(
          decoration: GradientSystem.gradient1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                LanguageSelectorWidget(
                  currentLanguages: viewModel.currentLanguages,
                  onPressed: () => viewModel.showLanguageSelectionModal(),
                ),
                const SizedBox(height: 30),
                //TODO-[API connection]
                const CurrentBook(
                  imageUrl: 'assets/images/current_book.png',
                  title: 'The Great Gatsby',
                  author: 'F. Scott Fitzgerald',
                  progress: 0.5,
                ),
                const SizedBox(height: 30),
                //TODO-[API connection]
                _buildContinueReadingButton(),
                const SizedBox(height: 40),
                RecommendedBooksWidget(
                  books: const [
                    RecommendedBook(
                      imageUrl: 'assets/images/recommended_book.png',
                      title: 'The Great Gatsby',
                      author: 'F. Scott Fitzgerald',
                    ),
                    RecommendedBook(
                      imageUrl: 'assets/images/recommended_book.png',
                      title: 'The Great Gatsby',
                      author: 'F. Scott Fitzgerald',
                    ),
                    RecommendedBook(
                      imageUrl: 'assets/images/recommended_book.png',
                      title: 'The Great Gatsby',
                      author: 'F. Scott Fitzgerald',
                    ),
                  ],
                  onViewAllPressed: () => print('모든 추천 책 보기 페이지로 이동'),
                  onBookPressed: (book) => print('책 상세 페이지로 이동'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueReadingButton() {
    return Center(
      child: StyledButton(
        onPressed: () {
          viewModel.continueReading(viewModel.currentBook);
        },
        text: 'Continue Reading',
        icon: const Icon(Icons.menu_book, color: Colors.white),
      ),
    );
  }
}
