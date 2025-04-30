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
    return Obx(() => Expanded(
          child: ListView.builder(
            itemCount: viewModel.uploadedFiles.length,
            itemBuilder: (context, index) {
              final file = viewModel.uploadedFiles[index];
              return _buildFileItem(file);
            },
          ),
        ));
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
          FileStatusButton(file: file),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          viewModel.uploadFile();
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
