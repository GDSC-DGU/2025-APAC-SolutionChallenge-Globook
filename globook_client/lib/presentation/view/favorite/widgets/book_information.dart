import 'package:flutter/material.dart';
import 'package:globook_client/domain/model/book.dart';

class BookInformation extends StatelessWidget {
  final Book book;

  const BookInformation({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          book.author,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
