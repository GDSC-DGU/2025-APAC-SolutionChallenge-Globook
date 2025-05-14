import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/domain/model/file.dart';
import 'package:intl/intl.dart';

class FileInformation extends StatelessWidget {
  final UserFile file;

  const FileInformation({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            file.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '업로드: ${_formatDate(file.createdAt)}',
            style: const TextStyle(
              fontSize: 12,
              color: ColorSystem.lightText,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd').format(date);
  }
}
