import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/core/view/base_widget.dart';
import 'package:globook_client/domain/enum/EbookDownloadStatus.dart';
import 'package:globook_client/presentation/view_model/book_store_detail/book_store_detail_view_model.dart';
import 'package:globook_client/presentation/widget/styled_button.dart';

class BookStatusButton extends BaseWidget<BookStoreDetailViewModel> {
  final BuildContext context;
  final EbookDownloadStatus? status;
  final VoidCallback showDownloadBottomSheet;

  const BookStatusButton({
    super.key,
    required this.context,
    required this.status,
    required this.showDownloadBottomSheet,
  });

  @override
  Widget buildView(BuildContext context) {
    final isRead = status == EbookDownloadStatus.read;
    final isDownloading = status == EbookDownloadStatus.downloading;
    final isDownload = status == EbookDownloadStatus.download;

    return StyledButton(
      backgroundColor: isRead ? ColorSystem.highlight : ColorSystem.light,
      onPressed: isDownloading
          ? () => Get.snackbar("Downloading...", "Please wait...")
          : isDownload
              ? () => showDownloadBottomSheet()
              : isRead
                  ? () {
                      if (viewModel.currentBook != null) {
                        LogUtil.debug(
                            'BookStoreDetailScreen: _buildStatusButton - currentBook: ${viewModel.currentBook!.id}');
                        Get.toNamed(
                            '/reader/${viewModel.currentBook!.userBookId}/0/BOOK');
                      } else {
                        Get.snackbar(
                            "Error", "Book information is not available");
                      }
                    }
                  : () {
                      if (viewModel.currentBook != null) {
                        LogUtil.debug(
                            'BookStoreDetailScreen: _buildStatusButton - currentBook: ${viewModel.currentBook!.id}');
                        Get.toNamed(
                            '/reader/${viewModel.currentBook!.userBookId}/0/BOOK');
                      } else {
                        Get.snackbar(
                            "Error", "Book information is not available");
                      }
                    },
      icon: Icon(
        isDownloading
            ? Icons.downloading
            : isDownload
                ? Icons.file_download_outlined
                : Icons.menu_book,
        color: isRead ? ColorSystem.white : ColorSystem.mainText,
      ),
      textColor: isRead ? ColorSystem.white : ColorSystem.mainText,
      text: isDownloading
          ? 'Downloading...'
          : isDownload
              ? 'Download'
              : 'Read',
      isDisabled: isDownloading,
      fontSize: 14,
    );
  }
}
