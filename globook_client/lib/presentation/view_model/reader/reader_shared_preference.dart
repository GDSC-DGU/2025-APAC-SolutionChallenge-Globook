import 'package:globook_client/domain/model/reader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:globook_client/app/utility/log_util.dart';

class ReaderSharedPreference {
  static const String LAST_TARGET_LANGUAGE_KEY = 'last_target_language';
  static const String LAST_TITLE_KEY = 'last_title';
  static const String LAST_TYPE_KEY = 'last_type';

  static const String LAST_MAX_INDEX_KEY = 'last_max_index';
  static const String LAST_CURRENT_INDEX_KEY = 'last_current_index';
  static const String LAST_PERSONA_KEY = 'last_persona';
  static const String LAST_IMAGE_URL_KEY = 'last_image_url';
  static const String LAST_ID_KEY = 'last_id';
  Future<void> saveLastParagraphsInfo(
      ParagraphsInfo? paragraphsInfo, int lastIndex) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (paragraphsInfo != null) {
        await prefs.setInt(LAST_ID_KEY, paragraphsInfo.id);
        await prefs.setString(LAST_TITLE_KEY, paragraphsInfo.title);
        await prefs.setString(LAST_TYPE_KEY, paragraphsInfo.type ?? '');
        await prefs.setString(
            LAST_TARGET_LANGUAGE_KEY, paragraphsInfo.targetLanguage);
        await prefs.setString(
            LAST_IMAGE_URL_KEY, paragraphsInfo.imageUrl ?? 'pdf');
        await prefs.setString(LAST_PERSONA_KEY, paragraphsInfo.persona);
        await prefs.setInt(LAST_MAX_INDEX_KEY, paragraphsInfo.maxIndex);
      }
      await prefs.setInt(LAST_CURRENT_INDEX_KEY, lastIndex);
      LogUtil.debug(
          '[saveLastParagraphsInfo] lastIndex: $lastIndex, paragraphsMaxIndex: ${paragraphsInfo?.maxIndex}');
    } catch (e) {
      LogUtil.error('마지막 책 정보 저장 중 오류 발생: $e');
    }
  }

  Future<ParagraphsInfo?> loadLastParagraphsInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt(LAST_ID_KEY);
      final title = prefs.getString(LAST_TITLE_KEY);
      final type = prefs.getString(LAST_TYPE_KEY);
      final imageUrl = prefs.getString(LAST_IMAGE_URL_KEY);
      final targetLanguage = prefs.getString(LAST_TARGET_LANGUAGE_KEY);
      final maxIndex = prefs.getInt(LAST_MAX_INDEX_KEY);
      final currentIndex = prefs.getInt(LAST_CURRENT_INDEX_KEY);
      final persona = prefs.getString(LAST_PERSONA_KEY);

      if (id != null &&
          title != null &&
          targetLanguage != null &&
          maxIndex != null &&
          currentIndex != null) {
        return ParagraphsInfo(
          id: id,
          title: title,
          type: type ?? '',
          targetLanguage: targetLanguage,
          maxIndex: maxIndex,
          currentIndex: currentIndex,
          persona: persona ?? '',
          imageUrl: imageUrl ?? '',
        );
      }
    } catch (e) {
      LogUtil.error('마지막 책 정보 로드 중 오류 발생: $e');
    }
    return null;
  }
}
