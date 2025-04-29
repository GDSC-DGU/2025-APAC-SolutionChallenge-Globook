import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/presentation/view/upload/widget/file_extension_icon.dart';
import 'package:globook_client/presentation/view/upload/widget/file_information.dart';
import 'package:globook_client/presentation/view/upload/widget/file_status_button.dart';
import 'package:globook_client/presentation/view_model/upload/upload_view_model.dart';

class UploadScreen extends BaseScreen<UploadViewModel> {
  const UploadScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 32),
          const Text(
            '파일 추가하기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildFileList(),
          ),
          _buildUploadButton(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        onChanged: (value) {
          viewModel.searchFiles(value);
        },
        decoration: const InputDecoration(
          hintText: '업로드한 파일명을 검색해보세요',
          hintStyle: TextStyle(
            color: ColorSystem.lightText,
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search, color: ColorSystem.lightText),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFileList() {
    return Obx(() => ListView.builder(
          itemCount: viewModel.uploadedFiles.length,
          itemBuilder: (context, index) {
            final file = viewModel.uploadedFiles[index];
            return _buildFileItem(file);
          },
        ));
  }

  Widget _buildFileItem(Map<String, dynamic> file) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
          '업로드',
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
