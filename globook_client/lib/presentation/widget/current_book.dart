import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';

class CurrentBook extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final double? progress; // 0.0 ~ 1.0

  const CurrentBook({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 200,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            author,
            style: const TextStyle(
              fontSize: 16,
              color: ColorSystem.lightText,
            ),
          ),
          const SizedBox(height: 8),
          if (progress != null)
            LinearProgressIndicator(
              value: progress,
              backgroundColor: ColorSystem.light,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(ColorSystem.highlight),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
        ],
      ),
    );
  }
}
