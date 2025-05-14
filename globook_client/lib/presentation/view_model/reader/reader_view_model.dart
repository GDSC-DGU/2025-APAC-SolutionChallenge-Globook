import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'dart:async';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/domain/model/reader.dart';
import 'package:globook_client/domain/usecase/reader/reader_usecase.dart';
import 'package:globook_client/presentation/view_model/reader/reader_shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

class ReaderViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */
  static const String FONT_SIZE_KEY = 'reader_font_size';
  static const String HIGHLIGHT_COLOR_KEY = 'highlight_color';
  static const String TEXT_COLOR_KEY = 'text_color';
  static const String READING_SPEED_KEY = 'reading_speed';
  static const double DEFAULT_FONT_SIZE = 16.0;
  static const double MIN_FONT_SIZE = 12.0;
  static const double MAX_FONT_SIZE = 24.0;
  static const double DEFAULT_HIGHLIGHT_OPACITY = 0.3;
  static const double DEFAULT_READING_SPEED = 1.0;
  static const double MIN_READING_SPEED = 0.5;
  static const double MAX_READING_SPEED = 2.0;

  /* -----------Dependency Injection of UseCase------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  final ReaderUseCase _readerUseCase = Get.find<ReaderUseCase>();

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxDouble _fontSize = DEFAULT_FONT_SIZE.obs;
  final Rx<Color> _currentTextColor = Colors.black.obs;
  final Rx<Color> _currentHighlightColor =
      Colors.yellow.withOpacity(DEFAULT_HIGHLIGHT_OPACITY).obs;
  // For Top Bar End------------------------------------------------------

  final RxDouble _readingProgress = 0.0.obs;
  final RxInt _currentPlayingIndex = (-1).obs;
  final RxBool _isPlaying = false.obs;
  final RxDouble _readingSpeed = DEFAULT_READING_SPEED.obs;

  // For Bottom Bar End------------------------------------------------------

  final Rx<ParagraphsInfo?> _currentParagraphsInfo = Rx<ParagraphsInfo?>(null);
  final RxList<TTSMDText> _highlights = <TTSMDText>[].obs;
  final RxString _playStatus = '준비'.obs;

  // For Main Reader Content End ---------------------------------------------

  final AudioPlayer _audioPlayer = AudioPlayer();

  // TTS Audio Player End -----------------------------------------------------

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  double get fontSize => _fontSize.value;
  double get readingProgress => _readingProgress.value;
  ParagraphsInfo? get currentParagraphsInfo => _currentParagraphsInfo.value;
  List<TTSMDText> get highlights => _highlights;
  Color get currentHighlightColor => _currentHighlightColor.value;
  Color get currentTextColor => _currentTextColor.value;
  bool get isPlaying => _isPlaying.value;
  int get currentPlayingIndex => _currentPlayingIndex.value;
  String get playStatus => _playStatus.value;
  double get readingSpeed => _readingSpeed.value;
  /* ------------------------------------------------------ */
  /* ----------------- Constructor ----------------------- */
  /* ------------------------------------------------------ */
  @override
  void onInit() {
    super.onInit();

    _loadSavedFontSize();
    _loadHighlightColor();
    _loadTextColor();
    _loadReadingSpeed();

    _loadBook();
    _setupAudioPlayerDebugger();
  }

  @override
  void onClose() {
    _audioPlayer.stop().then((_) {
      _audioPlayer.dispose();
    });
    super.onClose();
  }

  /* ------------------------------------------------------ */
  /* ----------------- Audio Methods --------------------- */
  /* ------------------------------------------------------ */
  void _setupAudioPlayerDebugger() {
    ProcessingState? lastState;
    DateTime? lastStateChangeTime;

    _audioPlayer.playerStateStream.listen((state) {
      // 동일한 상태가 짧은 시간 내에 반복되는 경우 무시
      if (lastState == state.processingState &&
          lastStateChangeTime != null &&
          DateTime.now().difference(lastStateChangeTime!) <
              const Duration(milliseconds: 100)) {
        return;
      }

      lastState = state.processingState;
      lastStateChangeTime = DateTime.now();

      LogUtil.info('Player state: ${state.processingState}');

      switch (state.processingState) {
        case ProcessingState.completed:
          LogUtil.info('Audio completed!');
          // Transition to the next highlight
          playNextHighlight();
          break;
        case ProcessingState.ready:
          LogUtil.info('Audio ready...');
          break;
        case ProcessingState.buffering:
          LogUtil.info('Audio buffering...');
          break;
        case ProcessingState.idle:
          LogUtil.info('Audio player is idle...');
          break;
        case ProcessingState.loading:
          LogUtil.info('Audio loading...');
          break;
        default:
          LogUtil.info('Other state: ${state.processingState}');
      }
    });

    _audioPlayer.playbackEventStream.listen(
      (event) {
        // Only log events when not buffering
        if (_audioPlayer.processingState != ProcessingState.buffering) {
          LogUtil.info('Playback event: $event');
        }
      },
      onError: (Object e, StackTrace stackTrace) {
        LogUtil.error('Audio player error: $e');
        _playStatus.value = 'Error: $e';
      },
    );
  }

  Future<void> playTTS() async {
    if (_highlights.isEmpty) {
      _playStatus.value = 'No text to play';
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
    _playStatus.value = 'Paused';
  }

  Future<void> playNextHighlight() async {
    if (_highlights.isEmpty) return;

    // Find the actual DB index of the currently playing highlight
    final currentHighlight = _highlights.firstWhere(
      (h) => h.index == _currentPlayingIndex.value,
      orElse: () => _highlights.first,
    );

    // Find the next highlight
    final nextHighlight = _highlights.firstWhere(
      (h) => h.index > currentHighlight.index,
      orElse: () => currentHighlight,
    );

    if (nextHighlight.index > currentHighlight.index) {
      _currentPlayingIndex.value = nextHighlight.index;
      if (_isPlaying.value) {
        await _playCurrentHighlight();
      }
    } else {
      // When transitioning from the last highlight
      _isPlaying.value = false;
      _currentPlayingIndex.value = -1;
      _playStatus.value = 'Completed';
    }
  }

  Future<void> playPreviousHighlight() async {
    if (_highlights.isEmpty) return;

    await _audioPlayer.stop();

    // Find the actual DB index of the currently playing highlight
    final currentHighlight = _highlights.firstWhere(
      (h) => h.index == _currentPlayingIndex.value,
      orElse: () => _highlights.first,
    );

    // Find the previous highlight
    final previousHighlight = _highlights.lastWhere(
      (h) => h.index < currentHighlight.index,
      orElse: () => currentHighlight,
    );

    if (previousHighlight.index < currentHighlight.index) {
      _currentPlayingIndex.value = previousHighlight.index;
      if (_isPlaying.value) {
        await _playCurrentHighlight();
      }
    } else {
      // When transitioning from the first highlight
      _currentPlayingIndex.value = _highlights.first.index;
      if (_isPlaying.value) {
        await _playCurrentHighlight();
      }
    }
  }

  Future<void> _playCurrentHighlight() async {
    if (_currentPlayingIndex.value < 0 ||
        _currentPlayingIndex.value >= _currentParagraphsInfo.value!.maxIndex) {
      _isPlaying.value = false;
      _currentPlayingIndex.value = -1;
      _playStatus.value = 'Completed';
      return;
    }

    // Find the currently playing highlight
    final highlight = _highlights.firstWhere(
      (h) => h.index == _currentPlayingIndex.value,
      orElse: () => _highlights.first,
    );

    _playStatus.value = 'Playing...';
    setReadingProgress(
        _currentPlayingIndex.value, _currentParagraphsInfo.value!.maxIndex);

    // Save the current playback position
    if (_currentParagraphsInfo.value != null) {
      await ReaderSharedPreference().saveLastParagraphsInfo(
        _currentParagraphsInfo.value!,
        _currentPlayingIndex.value,
      );
      LogUtil.debug('Saved playback position: ${_currentPlayingIndex.value}');
    }

    if (highlight.voiceFile.isNotEmpty) {
      try {
        // Stop previous playback
        await _audioPlayer.stop();

        // Set audio source and start playback
        await _audioPlayer.setSpeed(_readingSpeed.value);
        await _audioPlayer.setUrl(
          highlight.voiceFile,
          preload: true,
        );
        await _audioPlayer.play();

        LogUtil.info('Playback started');
      } catch (e) {
        LogUtil.error('Error playing audio: $e');
        _playStatus.value = 'Playback error';
      }
    } else {
      _playStatus.value = 'No audio file';
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
      LogUtil.error('Error loading highlight color: $e');
    }
  }

  Future<void> _saveHighlightColor(Color color) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(HIGHLIGHT_COLOR_KEY, color.value);
    } catch (e) {
      LogUtil.error('Error saving highlight color: $e');
    }
  }

  Future<void> _saveTextColor(Color color) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(TEXT_COLOR_KEY, color.value);
    } catch (e) {
      LogUtil.error('Error saving text color: $e');
    }
  }

  // Font Setting End ------------------------------------------------------
  Future<void> _loadBook() async {
    _isLoading.value = true;
    try {
      final int fileId = int.parse(Get.parameters['fileId'] ?? '0');
      final int index = int.parse(Get.parameters['index'] ?? '0');
      final String type = Get.parameters['type'] ?? '';
      LogUtil.info('fileId: $fileId, index: $index, type: $type');
      if (fileId != -1) {
        bool isFile = type == 'FILE';
        final response =
            await _readerUseCase.getTTSMDTextFirst(isFile, fileId, index);
        _highlights.value = response.paragraphList;
        _currentParagraphsInfo.value = response.paragraphsInfo;

        // 최초 진입 시 reading progress 초기화
        if (_currentParagraphsInfo.value != null) {
          final currentIndex =
              index > 0 ? index : _currentParagraphsInfo.value!.currentIndex!;
          final maxIndex = _currentParagraphsInfo.value!.maxIndex;
          setReadingProgress(currentIndex, maxIndex);
          LogUtil.debug(
              'Initial reading progress set: $currentIndex / $maxIndex');
        }

        // Save current book info
        await ReaderSharedPreference().saveLastParagraphsInfo(
          response.paragraphsInfo,
          index,
        );
      }
    } finally {
      _isLoading.value = false;
    }
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
        LogUtil.error('Error saving font size: $e');
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

  void setReadingProgress(int currentIndex, int maxIndex) {
    _readingProgress.value = currentIndex / maxIndex;
  }

  Future<void> setHighlightColor(Color color) async {
    _currentHighlightColor.value = color.withOpacity(DEFAULT_HIGHLIGHT_OPACITY);
    await _saveHighlightColor(color);
  }

  Future<void> setCurrentTextColor(Color color) async {
    _currentTextColor.value = color;
    await _saveTextColor(color);
  }

  void onScroll(double maxScroll, double currentScroll, double screenHeight) {
    if (_isLoadingMore.value) return;

    final delta = screenHeight * 0.2; // 화면 높이의 20%

    // 아래로 스크롤하여 끝에 가까워질 때
    if (maxScroll - currentScroll <= delta) {
      loadMoreAfter();
    }
    // 위로 스크롤하여 시작에 가까워질 때
    if (currentScroll <= delta) {
      loadMoreBefore();
    }
  }

  Future<void> playHighlight(TTSMDText highlight) async {
    final index = highlight.index;
    if (index == -1) return;

    _currentPlayingIndex.value = index;
    _isPlaying.value = true;
    await _playCurrentHighlight();
  }

  Future<void> _loadReadingSpeed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedSpeed = prefs.getDouble(READING_SPEED_KEY);
      if (savedSpeed != null) {
        _readingSpeed.value = savedSpeed;
      }
    } catch (e) {
      LogUtil.error('Error loading reading speed: $e');
      _readingSpeed.value = DEFAULT_READING_SPEED;
    }
  }

  Future<void> setReadingSpeed(double speed) async {
    if (speed >= MIN_READING_SPEED && speed <= MAX_READING_SPEED) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(READING_SPEED_KEY, speed);
        _readingSpeed.value = speed;

        // Update the playback speed of the audio player
        await _audioPlayer.setSpeed(speed);
      } catch (e) {
        LogUtil.error('Error saving reading speed: $e');
      }
    }
  }

  void addHighlights(List<TTSMDText> newHighlights) {
    _highlights.addAll(newHighlights);
  }

  void insertHighlights(List<TTSMDText> newHighlights) {
    _highlights.insertAll(0, newHighlights);
  }

  Future<void> loadMoreAfter() async {
    if (_isLoadingMore.value) return;
    _isLoadingMore.value = true;

    try {
      if (_highlights.isNotEmpty) {
        final lastIndex = _highlights.last.index;
        final fileId = int.parse(Get.parameters['fileId'] ?? '0');

        if (fileId != 0) {
          final response = await _readerUseCase.getTTSMDTextAfter(
              _currentParagraphsInfo.value!.type == 'FILE', fileId, lastIndex);
          if (response.paragraphList.isNotEmpty) {
            _highlights.addAll(response.paragraphList);
          }
        }
      }
    } finally {
      _isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreBefore() async {
    if (_isLoadingMore.value) return;
    _isLoadingMore.value = true;

    try {
      if (_highlights.isNotEmpty) {
        final firstIndex = _highlights.first.index;
        final fileId = int.parse(Get.parameters['fileId'] ?? '0');

        if (fileId != 0 && firstIndex > 0) {
          final response = await _readerUseCase.getTTSMDTextBefore(
              _currentParagraphsInfo.value!.type == 'FILE', fileId, firstIndex);
          if (response.paragraphList.isNotEmpty) {
            _highlights.insertAll(0, response.paragraphList);
          }
        }
      }
    } finally {
      _isLoadingMore.value = false;
    }
  }

  Future<ParagraphsInfo?> getLastParagraphsInfo() async {
    return await ReaderSharedPreference().loadLastParagraphsInfo();
  }
}
