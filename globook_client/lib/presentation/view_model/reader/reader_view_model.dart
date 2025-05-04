import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/reader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

class ReaderViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */
  static const String FONT_SIZE_KEY = 'reader_font_size';
  static const String HIGHLIGHTS_KEY = 'book_highlights_'; // bookId를 붙여서 사용
  static const String HIGHLIGHT_COLOR_KEY = 'highlight_color';
  static const String TEXT_COLOR_KEY = 'text_color';
  static const double DEFAULT_FONT_SIZE = 16.0;
  static const double MIN_FONT_SIZE = 12.0;
  static const double MAX_FONT_SIZE = 24.0;
  static const double DEFAULT_HIGHLIGHT_OPACITY = 0.3;

  /* -----------Dependency Injection of UseCase------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  // TODO: 필요한 UseCase 주입 (예: BookUseCase)

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxBool _isLoading = false.obs;
  final RxDouble _fontSize = DEFAULT_FONT_SIZE.obs;
  final Rx<Color> _currentTextColor = Colors.black.obs;
  final Rx<Color> _currentHighlightColor =
      Colors.yellow.withOpacity(DEFAULT_HIGHLIGHT_OPACITY).obs;
  // For Top Bar End------------------------------------------------------

  final RxDouble _readingProgress = 0.6.obs;
  final RxInt _totalIndex = 0.obs;
  final RxInt _currentPlayingIndex = (-1).obs;
  final RxBool _isPlaying = false.obs;

  // For Bottom Bar End------------------------------------------------------

  final RxMap<int, String> _pageContents = <int, String>{}.obs;
  final int _prefetchCount = 30; // 미리 로드할 문장의 수
  Timer? _scrollDebouncer;
  final Rx<Book?> _currentBook = Rx<Book?>(null);
  final RxList<TTSMDText> _highlights = <TTSMDText>[].obs;
  final RxString _playStatus = '준비'.obs;

  // For Main Reader Content End ---------------------------------------------

  final AudioPlayer _audioPlayer = AudioPlayer();

  // TTS Audio Player End -----------------------------------------------------

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  bool get isLoading => _isLoading.value;
  double get fontSize => _fontSize.value;
  double get readingProgress => _readingProgress.value;
  Book? get currentBook => _currentBook.value;
  List<TTSMDText> get highlights => _highlights;
  Color get currentHighlightColor => _currentHighlightColor.value;
  Color get currentTextColor => _currentTextColor.value;
  bool get isPlaying => _isPlaying.value;
  int get currentPlayingIndex => _currentPlayingIndex.value;
  String get playStatus => _playStatus.value;

  /* ------------------------------------------------------ */
  /* ----------------- Constructor ----------------------- */
  /* ------------------------------------------------------ */
  @override
  void onInit() {
    super.onInit();
    _loadSavedFontSize();
    _loadHighlightColor();
    _loadTextColor();
    _loadBook();
    _setupAudioPlayer();
    _loadSampleData();
  }

  @override
  void onClose() {
    _scrollDebouncer?.cancel();
    _audioPlayer.dispose();
    super.onClose();
  }

  /* ------------------------------------------------------ */
  /* ----------------- Audio Methods --------------------- */
  /* ------------------------------------------------------ */
  void _setupAudioPlayer() {
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_isPlaying.value) {
          playNextHighlight();
        }
      }
    });
  }

  Future<void> playTTS() async {
    if (_highlights.isEmpty) {
      _playStatus.value = '재생할 텍스트가 없습니다';
      return;
    }

    _isPlaying.value = true;
    if (_currentPlayingIndex.value == -1) {
      _currentPlayingIndex.value = 0;
    }
    await _playCurrentHighlight();
  }

  Future<void> pauseTTS() async {
    _isPlaying.value = false;
    await _audioPlayer.pause();
    _playStatus.value = '일시정지';
  }

  Future<void> playNextHighlight() async {
    if (_highlights.isEmpty) return;

    await _audioPlayer.stop();

    if (_currentPlayingIndex.value < _highlights.length - 1) {
      _currentPlayingIndex.value++;
      if (_isPlaying.value) {
        await _playCurrentHighlight();
      }
    } else {
      // 마지막 하이라이트에서 다음으로 넘어갈 때
      _isPlaying.value = false;
      _currentPlayingIndex.value = -1;
      _playStatus.value = '재생 완료';
    }
  }

  Future<void> playPreviousHighlight() async {
    if (_highlights.isEmpty) return;

    await _audioPlayer.stop();

    if (_currentPlayingIndex.value > 0) {
      _currentPlayingIndex.value--;
      if (_isPlaying.value) {
        await _playCurrentHighlight();
      }
    } else {
      // 첫 번째 하이라이트에서 이전으로 넘어갈 때
      _currentPlayingIndex.value = 0;
      if (_isPlaying.value) {
        await _playCurrentHighlight();
      }
    }
  }

  Future<void> _playCurrentHighlight() async {
    if (_currentPlayingIndex.value < 0 ||
        _currentPlayingIndex.value >= _highlights.length) {
      _isPlaying.value = false;
      _currentPlayingIndex.value = -1;
      _playStatus.value = '재생 완료';
      return;
    }

    final highlight = _highlights[_currentPlayingIndex.value];
    _playStatus.value = '재생 중...';

    try {
      if (highlight.voiceFile.isNotEmpty) {
        await _audioPlayer.setUrl(highlight.voiceFile);
        await _audioPlayer.play();
      } else {
        _playStatus.value = '음성 파일이 없습니다';
        // 300ms 후에 다음 하이라이트로 넘어감
        await Future.delayed(const Duration(milliseconds: 300));
        if (_isPlaying.value) {
          playNextHighlight();
        }
      }
    } catch (e) {
      print('음성 재생 중 오류 발생: $e');
      _playStatus.value = '오류: $e';
      await Future.delayed(const Duration(milliseconds: 300));
      if (_isPlaying.value) {
        playNextHighlight();
      }
    }
  }

  /* ------------------------------------------------------ */
  /* ----------------- Private Methods -------------------- */
  /* ------------------------------------------------------ */
  Future<void> _loadSavedFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFontSize = prefs.getDouble(FONT_SIZE_KEY);
      if (savedFontSize != null) {
        _fontSize.value = savedFontSize;
      }
    } catch (e) {
      print('폰트 크기 로드 중 오류 발생: $e');
      _fontSize.value = DEFAULT_FONT_SIZE;
    }
  }

  Future<void> _loadTextColor() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTextColor = prefs.getInt(TEXT_COLOR_KEY);
      if (savedTextColor != null) {
        _currentTextColor.value = Color(savedTextColor);
      }
    } catch (e) {
      print('텍스트 색상 로드 중 오류 발생: $e');
      _currentTextColor.value = Colors.black;
    }
  }

  Future<void> _loadHighlightColor() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final colorValue = prefs.getInt(HIGHLIGHT_COLOR_KEY);
      if (colorValue != null) {
        _currentHighlightColor.value =
            Color(colorValue).withOpacity(DEFAULT_HIGHLIGHT_OPACITY);
      }
    } catch (e) {
      print('하이라이트 색상 로드 중 오류 발생: $e');
    }
  }

  Future<void> _saveHighlightColor(Color color) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(HIGHLIGHT_COLOR_KEY, color.value);
    } catch (e) {
      print('하이라이트 색상 저장 중 오류 발생: $e');
    }
  }

  Future<void> _saveTextColor(Color color) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(TEXT_COLOR_KEY, color.value);
    } catch (e) {
      print('텍스트 색상 저장 중 오류 발생: $e');
    }
  }

  // Font Setting End ------------------------------------------------------
  Future<void> _loadBook() async {
    _isLoading.value = true;
    try {
      final String? bookId = Get.parameters['bookId'];
      if (bookId != null) {
        // TODO: API 호출로 대체
        _currentBook.value = const Book(
          id: '1',
          title: '데미안',
          author: '헤르만 헤세',
          imageUrl: 'assets/images/demian.png',
          description:
              '『데미안』은 노벨문학상 수상 작가 헤르만 헤세가 1919년에 에밀 싱클레어라는 가명으로 발표한 소설로, 부모님의 품처럼 온화하고 밝은 세계에만 속해 있던 주인공 싱클레어가 처음으로 어둡고 악한 세계에 발을 들이며 겪는 내면의 갈등과 변화를 그린 작품입니다.',
          category: 'fiction',
        );
        _highlights.value = _sampleHighlights;
        _initializeTestData();
      }
    } finally {
      _isLoading.value = false;
    }
  }

  void _initializeTestData() {
    _totalIndex.value = _sampleHighlights.length;
    _loadPagesWithPrefetch(0);
  }

  // Load Initial Data End------------------------------------------------------
  Future<void> _loadPagesWithPrefetch(int currentPage) async {
    int startPage = max(0, currentPage - _prefetchCount);
    int endPage = min(_totalIndex.value - 1, currentPage + _prefetchCount);
    await _loadPages(startPage, endPage);
  }

  Future<void> _loadPages(int startIndex, int endIndex) async {
    List<Future> futures = [];
    for (int i = startIndex; i <= endIndex; i++) {
      if (i >= 0 && i < _totalIndex.value && !_pageContents.containsKey(i)) {
        futures.add(_getPageContent(i).then((content) {
          _pageContents[i] = content;
        }));
      }
    }
    await Future.wait(futures);
  }

  Future<int> _getTotalPages(String bookId) async {
    return _sampleHighlights.length;
  }

  Future<String> _getPageContent(int pageNumber) async {
    if (pageNumber >= 0 && pageNumber < _sampleHighlights.length) {
      return _sampleHighlights[pageNumber].text;
    }
    return '';
  }

  /* ------------------------------------------------------ */
  /* ----------------- Public Methods --------------------- */
  /* ------------------------------------------------------ */
  Future<void> setFontSize(double size) async {
    if (size >= MIN_FONT_SIZE && size <= MAX_FONT_SIZE) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(FONT_SIZE_KEY, size);
        _fontSize.value = size;
      } catch (e) {
        print('폰트 크기 저장 중 오류 발생: $e');
      }
    }
  }

  Future<void> increaseFontSize() async {
    if (_fontSize.value < MAX_FONT_SIZE) {
      await setFontSize(_fontSize.value + 2);
    }
  }

  Future<void> decreaseFontSize() async {
    if (_fontSize.value > MIN_FONT_SIZE) {
      await setFontSize(_fontSize.value - 2);
    }
  }

  // Font 설정 끝 ------------------------------------------------------

  void setReadingProgress(double progress) {
    _readingProgress.value = progress;
  }

  Future<void> setHighlightColor(Color color) async {
    _currentHighlightColor.value = color.withOpacity(DEFAULT_HIGHLIGHT_OPACITY);
    await _saveHighlightColor(color);
  }

  Future<void> setCurrentTextColor(Color color) async {
    _currentTextColor.value = color;
    await _saveTextColor(color);
  }

  Future<void> loadInitialContent(String bookId) async {
    _isLoading.value = true;
    try {
      _totalIndex.value = await _getTotalPages(bookId);
      await _loadPagesWithPrefetch(_currentPlayingIndex.value);
    } finally {
      _isLoading.value = false;
    }
  }

  void onScroll(double scrollPosition) {
    _scrollDebouncer?.cancel();
    _scrollDebouncer = Timer(const Duration(milliseconds: 300), () {
      // int newIndex = (scrollPosition / _pageSize).floor();
    });
  }

  Future<void> playHighlight(TTSMDText highlight) async {
    final index = _highlights.indexOf(highlight);
    if (index == -1) return;

    _currentPlayingIndex.value = index;
    _isPlaying.value = true;
    await _playCurrentHighlight();
  }

  /* ------------------------------------------------------ */
  /* ----------------- Sample Data ----------------------- */
  /* ------------------------------------------------------ */
  final List<TTSMDText> _sampleHighlights = [
    TTSMDText(
      index: 0,
      text: "# 1장: 새로운 시작",
      voiceFile: "https://example.com/voice1.mp3",
    ),
    TTSMDText(
      index: 1,
      text: "이것은 첫 번째 페이지의 내용입니다. 여기서는 책의 시작을 알리는 중요한 내용이 담겨있습니다.",
      voiceFile: "https://example.com/voice2.mp3",
    ),
    TTSMDText(
      index: 2,
      text: "## 첫 번째 섹션",
      voiceFile: "https://example.com/voice3.mp3",
    ),
    TTSMDText(
      index: 3,
      text: "이 섹션에서는 주요 등장인물들의 소개가 이루어집니다. 각 캐릭터의 성격과 배경이 자세히 설명됩니다.",
      voiceFile: "https://example.com/voice4.mp3",
    ),
    TTSMDText(
      index: 4,
      text: "# 2장: 모험의 시작",
      voiceFile: "https://example.com/voice5.mp3",
    ),
    TTSMDText(
      index: 5,
      text: "두 번째 페이지에서는 본격적인 모험이 시작됩니다. 주인공은 첫 번째 시련에 직면하게 됩니다.",
      voiceFile: "https://example.com/voice6.mp3",
    ),
    TTSMDText(
      index: 6,
      text: "## 첫 번째 시련",
      voiceFile: "https://example.com/voice7.mp3",
    ),
    TTSMDText(
      index: 7,
      text: "주인공은 어려운 선택을 해야 합니다. 이 선택이 이후의 이야기에 큰 영향을 미치게 됩니다.",
      voiceFile: "https://example.com/voice8.mp3",
    ),
    TTSMDText(
      index: 8,
      text: "# 3장: 새로운 동맹",
      voiceFile: "https://example.com/voice9.mp3",
    ),
    TTSMDText(
      index: 9,
      text: "세 번째 페이지에서는 새로운 동맹이 등장합니다. 이들은 주인공의 여정에 큰 도움이 될 것입니다.",
      voiceFile: "https://example.com/voice10.mp3",
    ),
    TTSMDText(
      index: 10,
      text: "## 새로운 친구들",
      voiceFile: "https://example.com/voice11.mp3",
    ),
    TTSMDText(
      index: 11,
      text: "# 4장: 위험한 여정",
      voiceFile: "https://example.com/voice12.mp3",
    ),
    TTSMDText(
      index: 12,
      text: "네 번째 페이지에서는 위험한 여정이 시작됩니다. 주인공과 동료들은 여러 시련을 겪게 됩니다.",
      voiceFile: "https://example.com/voice13.mp3",
    ),
    TTSMDText(
      index: 13,
      text: "## 위험한 상황들",
      voiceFile: "https://example.com/voice14.mp3",
    ),
    TTSMDText(
      index: 14,
      text: "# 5장: 결말",
      voiceFile: "https://example.com/voice15.mp3",
    ),
    TTSMDText(
      index: 15,
      text: "마지막 페이지에서는 모든 이야기가 마무리됩니다. 주인공은 자신의 목표를 달성하고 성장합니다.",
      voiceFile: "https://example.com/voice16.mp3",
    ),
    TTSMDText(
      index: 16,
      text: "## 교훈",
      voiceFile: "https://example.com/voice17.mp3",
    ),
    TTSMDText(
      index: 17,
      text:
          "이 책은 모험과 성장의 이야기를 담고 있습니다. 주인공의 여정을 통해 독자는 자신의 목표를 이루고 성장할 수 있는 힘을 발견할 것입니다.",
      voiceFile: "https://example.com/voice18.mp3",
    ),
  ];

  void _loadSampleData() {
    _highlights.value = _sampleHighlights;
  }
}
