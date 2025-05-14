// TTS 하이라이트 데이터 모델
class ParagraphsInfo {
  final int id;
  final int maxIndex;
  String? imageUrl;
  final String title;
  String? type;
  final String targetLanguage;
  final String persona;
  int? currentIndex;

  ParagraphsInfo({
    required this.id,
    required this.maxIndex,
    this.imageUrl,
    required this.title,
    this.type,
    required this.targetLanguage,
    required this.persona,
    this.currentIndex,
  });

  factory ParagraphsInfo.fromJson(Map<String, dynamic> json) {
    return ParagraphsInfo(
      id: json['id'] as int,
      maxIndex: json['maxIndex'] as int,
      imageUrl: json['imageUrl'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
      targetLanguage: json['targetLanguage'] as String? ?? '',
      persona: json['persona'] as String? ?? '',
      currentIndex: json['currentIndex'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maxIndex': maxIndex,
      'title': title,
      'type': type,
      'targetLanguage': targetLanguage,
      'persona': persona,
      'currentIndex': currentIndex,
    };
  }
}

class TTSMDText {
  final int index;
  final String text;
  final String voiceFile;

  TTSMDText({
    required this.index,
    required this.text,
    required this.voiceFile,
  });

  factory TTSMDText.fromJson(Map<String, dynamic> json) {
    return TTSMDText(
      index: json['index'] as int,
      text: json['text'] as String,
      voiceFile: json['voiceFile'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'text': text,
      'voiceFile': voiceFile,
    };
  }

  TTSMDText copyWith({
    int? index,
    String? text,
    String? voiceFile,
    bool? isPlaying,
  }) {
    return TTSMDText(
      index: index ?? this.index,
      text: text ?? this.text,
      voiceFile: voiceFile ?? this.voiceFile,
    );
  }
}

class ReaderResponse {
  final ParagraphsInfo paragraphsInfo;
  final List<TTSMDText> paragraphList;

  ReaderResponse({
    required this.paragraphsInfo,
    required this.paragraphList,
  });

  factory ReaderResponse.fromJson(Map<String, dynamic> json) {
    return ReaderResponse(
      paragraphsInfo: ParagraphsInfo.fromJson(
          json['paragraphsInfo'] as Map<String, dynamic>),
      paragraphList: (json['paragraphList'] as List<dynamic>)
          .map((item) => TTSMDText.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paragraphsInfo': paragraphsInfo.toJson(),
      'paragraphList': paragraphList.map((item) => item.toJson()).toList(),
    };
  }
}
