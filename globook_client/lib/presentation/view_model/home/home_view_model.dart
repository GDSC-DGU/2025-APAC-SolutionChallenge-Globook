// lib/presentation/view_model/home/home_view_model.dart
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/presentation/view/home/widget/language_selection_modal.dart';
import 'package:globook_client/presentation/view/home/widget/language_selector.dart';

class HomeViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */
  final List<Language> availableLanguages = [
    const Language(code: 'ENG', name: 'English'),
    const Language(code: 'KOR', name: '한국어'),
    const Language(code: 'JPN', name: '日本語'),
    const Language(code: 'CHN', name: '中文'),
    const Language(code: 'ESP', name: 'Español'),
    const Language(code: 'FRA', name: 'Français'),
  ];

  /* -----------Dependency Injection of UseCase------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  // 필요한 UseCase 주입 (예: BookUseCase)

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxString _currentBook = RxString('');
  final RxList<Map<String, dynamic>> _recommendedBooks =
      RxList<Map<String, dynamic>>([]);
  final Rx<Language> _selectedSourceLanguage =
      Rx<Language>(const Language(code: 'ENG', name: 'English'));
  final Rx<Language> _selectedTargetLanguage =
      Rx<Language>(const Language(code: 'KOR', name: '한국어'));

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  String get currentBook => _currentBook.value;
  List<Map<String, dynamic>> get recommendedBooks => _recommendedBooks;
  Language get selectedSourceLanguage => _selectedSourceLanguage.value;
  Language get selectedTargetLanguage => _selectedTargetLanguage.value;
  LanguagePair get currentLanguages => LanguagePair(
        sourceLanguage: _selectedSourceLanguage.value.code,
        targetLanguage: _selectedTargetLanguage.value.code,
      );

  @override
  void onInit() async {
    super.onInit();
    // Dependency Injection
    // _bookUseCase = Get.find<BookUseCase>();

    // 초기 데이터 로드
    loadBooks();
  }

  void loadBooks() async {
    // 예시 데이터
    _currentBook.value = '데미안';

    _recommendedBooks.addAll([
      {
        'title': 'Beneath the Wheel',
        'author': '헤르만 헤세',
        'image': 'assets/books/beneath_the_wheel.jpg'
      },
      {
        'title': 'Crime and Punishment',
        'author': '표도르 도스토예프스키',
        'image': 'assets/books/crime_and_punishment.jpg'
      },
      {
        'title': 'Foster',
        'author': 'Claire Keegan',
        'image': 'assets/books/foster.jpg'
      }
    ]);
  }

  void continueReading(String bookTitle) {
    // 책 읽기 화면으로 이동하는 로직
    print('Continue reading: $bookTitle');
  }

  void updateSourceLanguage(Language language) {
    _selectedSourceLanguage.value = language;
  }

  void updateTargetLanguage(Language language) {
    _selectedTargetLanguage.value = language;
  }

  void showLanguageSelectionModal() {
    Get.bottomSheet(
      LanguageSelectionModal(
        languages: availableLanguages,
        initialSourceLanguage: selectedSourceLanguage,
        initialTargetLanguage: selectedTargetLanguage,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  void onReady() async {}
}
