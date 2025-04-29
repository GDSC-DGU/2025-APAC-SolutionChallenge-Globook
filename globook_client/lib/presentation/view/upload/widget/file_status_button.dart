import 'package:flutter/material.dart';
import 'package:globook_client/core/view/base_widget.dart';
import 'package:globook_client/presentation/view/upload/widget/read_button.dart';
import 'package:globook_client/presentation/view/upload/widget/translating_button.dart';
import 'package:globook_client/presentation/view/upload/widget/uploading_button.dart';
import 'package:globook_client/presentation/view_model/upload/upload_view_model.dart';

class FileStatusButton extends BaseWidget<UploadViewModel> {
  final Map<String, dynamic> file;

  const FileStatusButton({super.key, required this.file});

  @override
  Widget buildView(BuildContext context) {
    return switch (file['status']) {
      '업로드 중' => const UploadingStatusWidget(),
      '번역 중' => const TranslatingStatusWidget(),
      '완료' => ReadFileButton(
          onPressed: () {
            viewModel.readFile(file);
          },
        ),
      _ => const SizedBox(),
    };
  }
}
