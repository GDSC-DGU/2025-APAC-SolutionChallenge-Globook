import 'package:globook_client/domain/enum/EbookCategory.dart';
import 'package:globook_client/domain/enum/EbookDownloadStatus.dart';

class Book {
  final int id;
  final int? userBookId;
  final String title;
  final String author;
  final String imageUrl;
  final String? description;
  final EbookCategory? category;
  final List<Book>? otherBookList;
  final EbookDownloadStatus? downloadStatus;
  final bool? isFavorite;
  final int? totalIndex;
  final int? index;

  const Book({
    required this.id,
    this.userBookId,
    required this.title,
    required this.author,
    required this.imageUrl,
    this.description,
    this.category,
    this.otherBookList,
    this.downloadStatus,
    this.isFavorite,
    this.totalIndex,
    this.index,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      userBookId: json['userBookId'] as int?,
      title: json['title'] as String,
      author: json['author'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String?,
      category: json['category'] != null
          ? EbookCategory.values.firstWhere(
              (e) => e.toString().split('.').last == json['category'],
              orElse: () => EbookCategory.SCIENCE,
            )
          : null,
      otherBookList: json['otherBookList'] != null
          ? (json['otherBookList'] as List)
              .map((book) => Book.fromJson(book))
              .toList()
          : null,
      downloadStatus: json['download'] != null
          ? EbookDownloadStatus.values.firstWhere(
              (e) => e.toString().split('.').last == json['download'],
              orElse: () => EbookDownloadStatus.download,
            )
          : null,
      isFavorite: json['favorite'] as bool?,
      totalIndex: json['totalIndex'] as int?,
      index: json['index'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userBookId': userBookId,
        'title': title,
        'author': author,
        'imageUrl': imageUrl,
        'description': description,
        'category': category,
        'otherBookList': otherBookList?.map((book) => book.toJson()).toList(),
        'download': downloadStatus,
        'isFavorite': isFavorite,
        'totalIndex': totalIndex,
        'index': index,
      };
}
