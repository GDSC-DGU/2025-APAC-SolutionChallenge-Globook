// lib/presentation/view_model/home/home_view_model.dart
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:globook_client/presentation/view/home/widget/language_selection_modal.dart';
import 'package:globook_client/presentation/view/home/widget/language_selector.dart';

class HomeViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */
  static const String _sourceLanguageKey = 'source_language';
  static const String _targetLanguageKey = 'target_language';

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
  final RxList<Book> _anotherBooks = RxList<Book>([]);
  final Rx<Language> _selectedSourceLanguage =
      Rx<Language>(const Language(code: 'ENG', name: 'English'));
  final Rx<Language> _selectedTargetLanguage =
      Rx<Language>(const Language(code: 'KOR', name: '한국어'));

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  String get currentBook => _currentBook.value;
  List<Book> get anotherBooks => _anotherBooks;
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

    // 저장된 언어 설정 불러오기
    await _loadLanguageSettings();

    // 초기 데이터 로드
    await loadBooks();
  }

  Future<void> _loadLanguageSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final sourceCode = prefs.getString(_sourceLanguageKey) ?? 'ENG';
    final targetCode = prefs.getString(_targetLanguageKey) ?? 'KOR';

    _selectedSourceLanguage.value = _findLanguageByCode(sourceCode);
    _selectedTargetLanguage.value = _findLanguageByCode(targetCode);
  }

  Future<void> _saveLanguageSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _sourceLanguageKey, _selectedSourceLanguage.value.code);
    await prefs.setString(
        _targetLanguageKey, _selectedTargetLanguage.value.code);
  }

  Language _findLanguageByCode(String code) {
    return availableLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => availableLanguages.first,
    );
  }

  Future<void> loadBooks() async {
    // 예시 데이터
    _currentBook.value = '데미안';

    _anotherBooks.addAll([
      const Book(
        id: '1',
        title: 'Beneath the Wheel',
        author: '헤르만 헤세',
        imageUrl: 'assets/books/beneath_the_wheel.jpg',
        description: '',
        category: '',
        authorBooks: [],
      ),
      const Book(
        id: '2',
        title: 'Crime and Punishment',
        author: '표도르 도스토예프스키',
        imageUrl: 'assets/books/crime_and_punishment.jpg',
        description: '',
        category: '',
        authorBooks: [],
      ),
      const Book(
        id: '3',
        title: 'Foster',
        author: 'Claire Keegan',
        imageUrl: 'assets/books/foster.jpg',
        description: '',
        category: '',
        authorBooks: [],
      ),
    ]);
  }

  void continueReading(String bookTitle) {
    // 책 읽기 화면으로 이동하는 로직
    print('Continue reading: $bookTitle');
  }

  void updateSourceLanguage(Language language) {
    _selectedSourceLanguage.value = language;
    _saveLanguageSettings();
  }

  void updateTargetLanguage(Language language) {
    _selectedTargetLanguage.value = language;
    _saveLanguageSettings();
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
