import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/domain/model/file.dart';
import 'package:globook_client/presentation/widget/styled_button.dart';

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
    switch (file.status) {
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
      case FileStatus.translating:
        return StyledButton(
          onPressed: () {},
          text: 'translating',
          height: 28,
          textColor: ColorSystem.white,
          fontSize: 10,
          icon: const Icon(Icons.translate_rounded,
              color: ColorSystem.white, size: 16),
          backgroundColor: ColorSystem.load2,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        );
      case FileStatus.completed:
        return StyledButton(
          onPressed: () {
            // TODO: 파일 읽기 구현
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
