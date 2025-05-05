// lib/presentation/view_model/home/home_view_model.dart
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/usecase/home/home_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:globook_client/presentation/view/home/widget/language_selection_modal.dart';
import 'package:globook_client/presentation/view/home/widget/language_selector.dart';
import 'package:globook_client/app/utility/log_util.dart';

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
  late final HomeUseCase _homeUseCase;
  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final Rx<Book> _currentBook = Rx<Book>(const Book(
    id: '',
    title: '',
    author: '',
    imageUrl: '',
    description: '',
    category: '',
    authorBooks: [],
  ));
  final RxList<Book> _anotherBooks = RxList<Book>([]);
  final Rx<Language> _selectedSourceLanguage =
      Rx<Language>(const Language(code: 'ENG', name: 'English'));
  final Rx<Language> _selectedTargetLanguage =
      Rx<Language>(const Language(code: 'KOR', name: '한국어'));

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  Book get currentBook => _currentBook.value;
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
    _homeUseCase = Get.find<HomeUseCase>();

    // Load Language Settings
    await _loadLanguageSettings();

    // Initialize Data
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
    final lastReadBook = await _homeUseCase.getLastReadBook();

    final libraryBooks = await _homeUseCase.getLibraryBooks();

    _currentBook.value = lastReadBook;
    _anotherBooks.clear();
    _anotherBooks.addAll(libraryBooks);
  }

  void continueReading(String bookTitle) {
    // 책 읽기 화면으로 이동하는 로직
    Get.toNamed(AppRoutes.READER, arguments: bookTitle);
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
