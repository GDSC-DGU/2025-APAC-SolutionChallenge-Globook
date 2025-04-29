// lib/presentation/view/upload/widget/translating_status_widget.dart
import 'package:flutter/material.dart';

class TranslatingStatusWidget extends StatelessWidget {
  const TranslatingStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF001F7F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.translate, size: 16, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Translating',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
