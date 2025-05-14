import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/domain/enum/Efile.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/file.dart';
import 'package:globook_client/presentation/view_model/root/root_view_model.dart';
import 'package:globook_client/presentation/view_model/storage/storage_view_model.dart';
import 'package:globook_client/presentation/widget/styled_button.dart';

class StorageScreen extends BaseScreen<StorageViewModel> {
  const StorageScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '보관함',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Obx(() => viewModel.isLoading
                ? _buildLoadingSection('My files')
                : _buildSection('My files', viewModel.myFiles)),
            const SizedBox(height: 24),
            Obx(() => viewModel.isLoading
                ? _buildLoadingSection('Downloaded books')
                : _buildSection('Downloaded books', viewModel.books)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: ColorSystem.light,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<dynamic> items) {
    final rootViewModel = Get.find<RootViewModel>();
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: 전체보기 구현
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: ColorSystem.light,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        title == 'My files'
                            ? Icons.insert_drive_file
                            : Icons.menu_book,
                        size: 48,
                        color: ColorSystem.lightText,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title == 'My files'
                            ? 'No files uploaded yet.'
                            : 'No books owned yet.',
                        style: const TextStyle(
                          fontSize: 15,
                          color: ColorSystem.lightText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      StyledButton(
                        onPressed: () {
                          title == 'My files'
                              ? rootViewModel.changeIndex(0)
                              : rootViewModel.changeIndex(3);
                        },
                        text: title == 'My files'
                            ? 'Click the button below to add a file!'
                            : 'Click the + button below to add a book!',
                        textColor: ColorSystem.white,
                        backgroundColor: ColorSystem.highlight,
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: ColorSystem.light,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 150,
                  child: title == 'Downloaded books'
                      ? _buildBookList()
                      : _buildFileList(),
                ),
              ),
          ],
        ));
  }

  Widget _buildFileList() {
    return Obx(() {
      final files = viewModel.myFiles
          .where((file) => file.fileStatus == FileStatus.read)
          .toList();
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: files.length,
        itemBuilder: (context, index) {
          return _buildFileItem(files[index]);
        },
      );
    });
  }

  Widget _buildFileItem(UserFile file) {
    return GestureDetector(
      onTap: () {
        viewModel.readFile(file.id, 0, 'FILE');
      },
      child: Container(
        width: 92,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/icons/svg/pdf.svg',
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              file.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookList() {
    return Obx(() {
      final books = viewModel.books;
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          return _buildBookItem(books[index]);
        },
      );
    });
  }

  Widget _buildBookItem(Book book) {
    return Container(
      width: 92,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: 80,
              height: 100,
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
  }
}
