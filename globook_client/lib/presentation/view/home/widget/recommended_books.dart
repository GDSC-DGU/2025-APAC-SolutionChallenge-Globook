import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';

class RecommendedBook {
  final String imageUrl;
  final String title;
  final String author;

  const RecommendedBook({
    required this.imageUrl,
    required this.title,
    required this.author,
  });
}

class RecommendedBooksWidget extends StatelessWidget {
  final List<RecommendedBook> books;
  final VoidCallback onViewAllPressed;
  final Function(RecommendedBook book) onBookPressed;

  const RecommendedBooksWidget({
    super.key,
    required this.books,
    required this.onViewAllPressed,
    required this.onBookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildContainerDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildBookList(),
        ],
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: ColorSystem.white,
      borderRadius: BorderRadius.circular(4),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Another Books in Your Library',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: onViewAllPressed,
        ),
      ],
    );
  }

  Widget _buildBookList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return _buildBookItem(book);
        },
      ),
    );
  }

  Widget _buildBookItem(RecommendedBook book) {
    return GestureDetector(
      onTap: () => onBookPressed(book),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookCover(book),
            const SizedBox(height: 8),
            _buildBookInfo(book),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCover(RecommendedBook book) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(book.imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildBookInfo(RecommendedBook book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          book.author,
          style: const TextStyle(
            fontSize: 10,
            color: ColorSystem.lightText,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
