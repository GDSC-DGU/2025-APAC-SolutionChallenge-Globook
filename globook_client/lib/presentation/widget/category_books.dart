import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/domain/model/book.dart';

class CategoryBooks extends StatelessWidget {
  final String title;
  final List<Book> books;
  final VoidCallback onViewAllPressed;
  final Function(Book book) onBookPressed;
  final double height;
  final double itemWidth;
  final double itemHeight;
  final double itemSpacing;
  final bool showAuthor;

  const CategoryBooks({
    super.key,
    required this.title,
    required this.books,
    required this.onViewAllPressed,
    required this.onBookPressed,
    this.height = 200,
    this.itemWidth = 120,
    this.itemHeight = 150,
    this.itemSpacing = 16,
    this.showAuthor = true,
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
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
      height: height,
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

  Widget _buildBookItem(Book book) {
    return GestureDetector(
      onTap: () => onBookPressed(book),
      child: Container(
        width: itemWidth,
        margin: EdgeInsets.only(right: itemSpacing),
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

  Widget _buildBookCover(Book book) {
    return Container(
      height: itemHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(book.imageUrl),
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

  Widget _buildBookInfo(Book book) {
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
        if (showAuthor) ...[
          const SizedBox(height: 2),
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
      ],
    );
  }
}
