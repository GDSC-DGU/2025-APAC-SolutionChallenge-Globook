// TTS 하이라이트 데이터 모델
class TTSMDText {
  final int index;
  final String text;
  final String voiceFile;

  TTSMDText({
    required this.index,
    required this.text,
    required this.voiceFile,
  });

  Map<String, dynamic> toJson() => {
        'index': index,
        'text': text,
        'voiceFile': voiceFile,
      };

  factory TTSMDText.fromJson(Map<String, dynamic> json) => TTSMDText(
        index: json['index'],
        text: json['text'],
        voiceFile: json['voiceFile'],
      );

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
