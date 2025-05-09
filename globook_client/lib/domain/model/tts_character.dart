import 'package:globook_client/domain/enum/EttsGender.dart';

class TtsCharacter {
  final String name;
  final String description;
  final String assetPath;
  final TtsGender gender;
  double speed;
  double pitch;
  TtsCharacter({
    required this.name,
    required this.description,
    required this.assetPath,
    required this.gender,
    required this.speed,
    required this.pitch,
  });
}
