// lib/presentation/view/home/widget/language_selection_modal.dart
import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_widget.dart';
import 'package:globook_client/presentation/view_model/home/home_view_model.dart';
import 'package:get/get.dart';
import 'package:globook_client/presentation/widget/styled_button.dart';

class Language {
  final String code;
  final String name;

  const Language({
    required this.code,
    required this.name,
  });
}

class LanguageSelectionModal extends BaseWidget<HomeViewModel> {
  final List<Language> languages;
  final Language initialSourceLanguage;
  final Language initialTargetLanguage;

  const LanguageSelectionModal({
    super.key,
    required this.languages,
    required this.initialSourceLanguage,
    required this.initialTargetLanguage,
  });

  @override
  Widget buildView(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Obx(
        () => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ColorSystem.highlight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Language Selection',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildLanguageList(
                      title: 'Source Language',
                      selectedLanguage: viewModel.selectedSourceLanguage,
                      onLanguageSelected: (language) {
                        viewModel.updateSourceLanguage(language);
                      },
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: _buildLanguageList(
                      title: 'Translation Language',
                      selectedLanguage: viewModel.selectedTargetLanguage,
                      onLanguageSelected: (language) {
                        viewModel.updateTargetLanguage(language);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  viewModel
                      .updateSourceLanguage(viewModel.selectedSourceLanguage);
                  viewModel
                      .updateTargetLanguage(viewModel.selectedTargetLanguage);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorSystem.highlight,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: StyledButton(
                  onPressed: () {
                    viewModel
                        .updateSourceLanguage(viewModel.selectedSourceLanguage);
                    viewModel
                        .updateTargetLanguage(viewModel.selectedTargetLanguage);
                    Navigator.pop(context);
                  },
                  text: "Save",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageList({
    required String title,
    required Language selectedLanguage,
    required Function(Language) onLanguageSelected,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              final isSelected = language.code == selectedLanguage.code;

              return ListTile(
                title: Text(
                  language.name,
                  style: TextStyle(
                    color: isSelected ? ColorSystem.highlight : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_circle,
                        color: ColorSystem.highlight,
                      )
                    : null,
                onTap: () => onLanguageSelected(language),
              );
            },
          ),
        ),
      ],
    );
  }
}
