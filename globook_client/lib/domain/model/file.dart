import 'package:globook_client/domain/enum/Efile.dart';

class UserFile {
  final String id;
  final String name;
  final String previewUrl;
  final String fileUrl;
  final FileType fileType;
  final DateTime uploadedAt;
  final FileStatus status;

  const UserFile({
    required this.id,
    required this.name,
    required this.previewUrl,
    required this.fileUrl,
    required this.fileType,
    required this.uploadedAt,
    required this.status,
  });

  factory UserFile.fromJson(Map<String, dynamic> json) {
    return UserFile(
      id: json['id'] as String,
      name: json['name'] as String,
      previewUrl: json['previewUrl'] as String,
      fileUrl: json['fileUrl'] as String,
      fileType: FileType.values.firstWhere(
        (e) => e.toString() == 'FileType.${json['fileType']}',
        orElse: () => FileType.other,
      ),
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      status: FileStatus.values.firstWhere(
        (e) => e.toString() == 'FileStatus.${json['status']}',
        orElse: () => FileStatus.uploading,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'previewUrl': previewUrl,
      'fileUrl': fileUrl,
      'fileType': fileType.toString().split('.').last,
      'uploadedAt': uploadedAt.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }
}
