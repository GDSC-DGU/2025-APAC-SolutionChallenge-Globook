import 'package:globook_client/domain/enum/Efile.dart';

class UserFile {
  final int id;
  final String title;
  final String language;
  final FileStatus fileStatus;
  final DateTime createdAt;

  UserFile({
    required this.id,
    required this.title,
    required this.language,
    required this.fileStatus,
    required this.createdAt,
  });

  factory UserFile.fromJson(Map<String, dynamic> json) {
    return UserFile(
      id: json['id'] as int,
      title: json['title'] as String,      language: json['language'] as String,
      fileStatus: FileStatus.values.firstWhere(
        (e) => e.toString().split('.').last.toUpperCase() == json['fileStatus'],
        orElse: () => FileStatus.uploading,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'language': language,
      'fileStatus': fileStatus.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
