import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/domain/model/file.dart';
import 'package:globook_client/presentation/view/upload/widget/file_extension_icon.dart';
import 'package:globook_client/presentation/view/upload/widget/file_information.dart';
import 'package:globook_client/presentation/view/upload/widget/file_status_button.dart';
import 'package:globook_client/presentation/view_model/upload/upload_view_model.dart';
import 'package:globook_client/presentation/widget/search_field.dart';
import 'package:globook_client/presentation/widget/book_read_setting_bottom_sheet.dart';

class UploadScreen extends BaseScreen<UploadViewModel> {
  const UploadScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SearchField(
            hintText: 'Search uploaded files',
            onChanged: (value) {
              viewModel.searchFiles(value);
            },
          ),
          const SizedBox(height: 32),
          const Text(
            'Add File',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFileList(),
          _buildUploadButton(),
        ],
      ),
    );
  }

  Widget _buildFileList() {
    return Obx(() {
      if (viewModel.uploadedFile.isEmpty) {
        return Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.insert_drive_file,
                    size: 60, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No uploaded files',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Click Upload button on the bottom to add a file',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // 파일이 있을 때 기존 리스트
      return Expanded(
        child: ListView.builder(
          itemCount: viewModel.uploadedFile.length,
          itemBuilder: (context, index) {
            final file = viewModel.uploadedFile[index];
            return _buildFileItem(file);
          },
        ),
      );
    });
  }

  Widget _buildFileItem(UserFile file) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FileExtensionIcon(file: file),
          const SizedBox(width: 16),
          FileInformation(file: file),
          const SizedBox(width: 16),
          Text(
            _getTargetLanguageEmoji(file.language),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          FileStatusButton(file: file),
        ],
      ),
    );
  }

  String _getTargetLanguageEmoji(String language) {
    switch (language.toUpperCase()) {
      case 'EN':
        return '🇺🇸';
      case 'KO':
        return '🇰🇷';
      case 'JA':
        return '🇯🇵';
      case 'ZH':
        return '🇨🇳';
      case 'ES':
        return '🇪🇸';
      case 'FR':
        return '��🇷';
      case 'DE':
        return '🇩🇪';
      case 'IT':
        return '🇮🇹';
      case 'PT':
        return '🇵🇹';
      case 'RU':
        return '🇷🇺';
      default:
        return '';
    }
  }

  Widget _buildUploadButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          showModalBottomSheet(
            context: Get.context!,
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
                child: const BookReadSettingBottomSheet(
                  isFromUpload: true,
                ),
              ),
            ),
          );
        },
        icon: const Icon(Icons.upload_file, color: Colors.white),
        label: const Text(
          'Upload',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorSystem.highlight,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
