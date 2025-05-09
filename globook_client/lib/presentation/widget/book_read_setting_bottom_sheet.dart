import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_widget.dart';
import 'package:globook_client/domain/enum/EttsGender.dart';
import 'package:globook_client/domain/model/tts_character.dart';
import 'package:globook_client/presentation/view_model/book_store/book_store_view_model.dart';

class BookReadSettingBottomSheet extends BaseWidget<BookStoreViewModel> {
  const BookReadSettingBottomSheet({super.key});

  @override
  Widget buildView(BuildContext context) {
    return _BookReadSettingBottomSheetContent();
  }
}

class _BookReadSettingBottomSheetContent extends StatefulWidget {
  @override
  State<_BookReadSettingBottomSheetContent> createState() =>
      _BookReadSettingBottomSheetContentState();
}

class _BookReadSettingBottomSheetContentState
    extends State<_BookReadSettingBottomSheetContent> {
  final List<String> languages = [
    'English',
    '한국어',
    '日本語',
    'Español',
    'Français',
    'Deutsch',
    'Italiano',
    'Português',
    'Русский',
    'Gaeilge'
  ];
  final List<TtsCharacter> characters = [
    TtsCharacter(
        name: 'Ethan',
        description: 'Calm • Novel, History Book',
        assetPath: 'assets/icons/png/ethan.png',
        gender: TtsGender.male,
        speed: 0.7,
        pitch: 0.7),
    TtsCharacter(
        name: 'Luna',
        description: 'Bright and lively • Essay, Self-help Book',
        assetPath: 'assets/icons/png/luna.png',
        gender: TtsGender.female,
        speed: 1.3,
        pitch: 1.0),
    TtsCharacter(
        name: 'Kai',
        description: 'Lively • Web Novel, Fantasy',
        assetPath: 'assets/icons/png/kai.png',
        gender: TtsGender.male,
        speed: 1.3,
        pitch: 1.3),
    TtsCharacter(
        name: 'Sora',
        description: 'Warm and friendly • Children\'s Book',
        assetPath: 'assets/icons/png/sora.png',
        gender: TtsGender.female,
        speed: 1.0,
        pitch: 1.3),
    TtsCharacter(
        name: 'Noah',
        description: 'Comfortable and stable • All Genres',
        assetPath: 'assets/icons/png/noah.png',
        gender: TtsGender.male,
        speed: 1.0,
        pitch: 1.0),
    TtsCharacter(
        name: 'Aria',
        description: 'Deep and captivating • Mystery, Romance',
        assetPath: 'assets/icons/png/aria.png',
        gender: TtsGender.female,
        speed: 0.7,
        pitch: 0.7),
  ];

  int step = 0; // 0: language, 1: character
  int? selectedLanguageIdx;
  int? selectedCharacterIdx;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: step == 0 ? _buildLanguageStep() : _buildCharacterStep(),
    );
  }

  Widget _buildLanguageStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Select the language to translate',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: languages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.5,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (context, idx) {
            return GestureDetector(
              onTap: () => setState(() => selectedLanguageIdx = idx),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                  color: selectedLanguageIdx == idx
                      ? Colors.blue.shade50
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selectedLanguageIdx == idx
                        ? Colors.blue
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  languages[idx],
                  style: TextStyle(
                    color:
                        selectedLanguageIdx == idx ? Colors.blue : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: selectedLanguageIdx != null
              ? () => setState(() => step = 1)
              : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: ColorSystem.highlight,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Next',
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildCharacterStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Select the character to read',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: characters.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, idx) {
            final c = characters[idx];
            return GestureDetector(
              onTap: () => setState(() => selectedCharacterIdx = idx),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: selectedCharacterIdx == idx
                        ? Colors.blue
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(c.assetPath),
                      radius: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(c.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: c.gender == TtsGender.male
                                      ? Colors.blue.shade100
                                      : Colors.pink.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  c.gender == TtsGender.male
                                      ? 'Male'
                                      : 'Female',
                                  style: TextStyle(
                                    color: c.gender == TtsGender.male
                                        ? Colors.blue
                                        : Colors.pink,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(c.description,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text('Speed',
                                  style: TextStyle(fontSize: 12)),
                              Expanded(
                                child: Slider(
                                  min: 0.5,
                                  max: 1.5,
                                  divisions: 15,
                                  value: c.speed,
                                  onChanged: selectedCharacterIdx == idx
                                      ? (v) => setState(() => c.speed = v)
                                      : null,
                                ),
                              ),
                              Text('${c.speed.toStringAsFixed(2)}x',
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Pitch',
                                  style: TextStyle(fontSize: 12)),
                              Expanded(
                                child: Slider(
                                  min: 0.5,
                                  max: 1.5,
                                  divisions: 10,
                                  value: c.pitch,
                                  onChanged: selectedCharacterIdx == idx
                                      ? (v) => setState(() => c.pitch = v)
                                      : null,
                                ),
                              ),
                              Text('${c.pitch.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      selectedCharacterIdx == idx
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: selectedCharacterIdx == idx
                          ? Colors.blue
                          : Colors.grey,
                      size: 28,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: selectedCharacterIdx != null
              ? () => Navigator.pop(context)
              : null,
          icon: const Icon(Icons.check, color: Colors.white),
          label: const Text('Complete',
              style: TextStyle(fontSize: 16, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
