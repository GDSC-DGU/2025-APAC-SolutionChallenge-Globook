import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/domain/enum/Efile.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/file.dart';
import 'package:globook_client/presentation/widget/styled_button.dart';
import 'package:lottie/lottie.dart';

class FileStatusButton extends StatelessWidget {
  final UserFile file;
  const FileStatusButton({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return _buildButton();
  }

  Widget _buildButton() {
    switch (file.fileStatus) {
      case FileStatus.uploading:
        return StyledButton(
          height: 32,
          onPressed: () {},
          text: 'uploading',
          icon: const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              color: ColorSystem.white,
              strokeWidth: 2,
            ),
          ),
          textColor: ColorSystem.white,
          fontSize: 10,
          backgroundColor: ColorSystem.lightText,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        );
      case FileStatus.processing:
        return StyledButton(
          onPressed: () {
            Get.snackbar(
              'translation',
              'translation is processing',
              backgroundColor: ColorSystem.lightText,
              colorText: ColorSystem.white,
            );
          },
          text: 'translation',
          height: 28,
          textColor: ColorSystem.white,
          fontSize: 10,
          icon: Lottie.asset(
            'assets/animations/translation_animation.json',
            fit: BoxFit.contain,
            width: 20,
            height: 20,
            repeat: true,
          ),
          backgroundColor: ColorSystem.load2,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        );
      case FileStatus.read:
        return StyledButton(
          onPressed: () {
            Get.toNamed('/reader/${file.id}/0/FILE');
          },
          text: 'read',
          height: 28,
          textColor: ColorSystem.white,
          fontSize: 10,
          icon: const Icon(Icons.library_books_rounded,
              color: ColorSystem.white, size: 16),
          backgroundColor: ColorSystem.highlight,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        );
    }
  }
}
