import 'package:flutter/material.dart';
import 'package:globook_client/domain/model/book.dart';

class FeaturedBooksCarousel extends StatefulWidget {
  final String title;
  final List<Book> books;
  final Function(Book book) onBookPressed;

  const FeaturedBooksCarousel({
    super.key,
    required this.title,
    required this.books,
    required this.onBookPressed,
  });

  @override
  State<FeaturedBooksCarousel> createState() => _FeaturedBooksCarouselState();
}

class _FeaturedBooksCarouselState extends State<FeaturedBooksCarousel> {
  late PageController _pageController;
  double _currentPage = 1.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.45,
      initialPage: 1,
    );
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    setState(() {
      _currentPage = _pageController.page ?? 1.0;
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.books.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildCarousel(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 280,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.books.length,
        itemBuilder: (context, index) {
          return _buildCarouselItem(index);
        },
      ),
    );
  }

  Widget _buildCarouselItem(int index) {
    final book = widget.books[index];
    double value = index - _currentPage;
    value = (value * 0.025).clamp(-1, 1);

    return Transform.rotate(
      angle: value,
      child: _buildAnimatedItem(index, _buildBookCard(book)),
    );
  }

  Widget _buildAnimatedItem(int index, Widget child) {
    final double pageOffset = (index - _currentPage).abs();
    final double scale = 1 - (pageOffset * 0.2).clamp(0.0, 0.3);
    final double opacity = 1 - (pageOffset * 0.4).clamp(0.0, 0.5);

    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: child,
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () => widget.onBookPressed(book),
        child: Column(
          children: [
            _buildBookCover(book),
            const SizedBox(height: 12),
            _buildBookTitle(book),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCover(Book book) {
    return Container(
      width: 160,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(book.imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildBookTitle(Book book) {
    return Text(
      book.title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}
