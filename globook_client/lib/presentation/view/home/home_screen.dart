import 'package:flutter/material.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/presentation/view/home/widget/current_paragrapth.dart';
import 'package:globook_client/presentation/widget/category_books.dart';

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
            child: viewModel.isLoading
                ? _buildLoadingState()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      CurrentParagraph(
                        paragraphsInfo: viewModel.currentParagraphsInfo,
                      ),
                      const SizedBox(height: 30),
                      _buildContinueReadingButton(),
                      const SizedBox(height: 40),
                      CategoryBooks(
                        title: 'Another Books in Your Library',
                        books: viewModel.anotherBooks,
                        onViewAllPressed: () {
                          Get.toNamed(AppRoutes.BOOK_STORE);
                        },
                        onBookPressed: (book) {
                          Get.toNamed(AppRoutes.BOOK_STORE_DETAIL,
                              arguments: book.id);
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          CircularProgressIndicator(
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            '로딩 중...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueReadingButton() {
    return Center(
      child: StyledButton(
        onPressed: () {
          if (viewModel.currentParagraphsInfo.id == -1) {
            Get.toNamed(AppRoutes.BOOK_STORE);
          } else {
            viewModel.continueReading(
                viewModel.currentParagraphsInfo.id,
                viewModel.currentParagraphsInfo.currentIndex ?? 0,
                viewModel.currentParagraphsInfo.type ?? '');
          }
        },
        text: viewModel.currentParagraphsInfo.id == -1
            ? 'Go to Book Store'
            : 'Continue Reading',
        icon: const Icon(Icons.menu_book, color: Colors.white),
      ),
    );
  }
}
