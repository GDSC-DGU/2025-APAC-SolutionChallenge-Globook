import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';

class FileInformation extends StatelessWidget {
  final Map<String, dynamic> file;

  const FileInformation({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            file['fileName'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            file['uploadTime'],
            style: const TextStyle(
              fontSize: 12,
              color: ColorSystem.lightText,
            ),
          ),
          if (file['pages'] != null) ...[
            const SizedBox(height: 4),
            Text(
              '${file['pages']}/1',
              style: const TextStyle(
                fontSize: 12,
                color: ColorSystem.lightText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
