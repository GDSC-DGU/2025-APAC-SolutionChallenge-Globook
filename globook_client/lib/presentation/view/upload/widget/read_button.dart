// lib/presentation/view/upload/widget/translating_status_widget.dart
import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';

class ReadFileButton extends StatelessWidget {
  const ReadFileButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ColorSystem.highlight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.library_books_rounded, size: 16, color: Colors.white),
          SizedBox(width: 12),
          Text(
            'Read',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
