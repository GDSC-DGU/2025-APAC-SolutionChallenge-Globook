class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String description;
  final String category;
  final List<Book> authorBooks;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.description,
    required this.category,
    this.authorBooks = const [],
  });
}
