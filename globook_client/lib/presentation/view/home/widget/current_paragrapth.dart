import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/domain/model/reader.dart';

class CurrentParagraph extends StatelessWidget {
  final ParagraphsInfo paragraphsInfo;

  const CurrentParagraph({
    super.key,
    required this.paragraphsInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/svg/global.svg',
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                color: ColorSystem.mainText,
                size: 32,
              ),
              const SizedBox(width: 8),
              Text(
                _getTargetLanguageEmoji(paragraphsInfo.targetLanguage),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: ColorSystem.highlight,
                ),
              ),
              const SizedBox(width: 8),
              Image.asset(
                _getPersonaImage(paragraphsInfo.persona),
                width: 50,
                height: 50,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: 200,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              color: Colors.white,
            ),
            child: paragraphsInfo.title.toLowerCase().endsWith('.pdf')
                ? SvgPicture.asset(
                    'assets/icons/svg/pdf.svg',
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    paragraphsInfo.imageUrl!,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            paragraphsInfo.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (paragraphsInfo.currentIndex != null)
            LinearProgressIndicator(
              value: paragraphsInfo.currentIndex!.toDouble() /
                  paragraphsInfo.maxIndex.toDouble(),
              backgroundColor: ColorSystem.light,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(ColorSystem.highlight),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
        ],
      ),
    );
  }

  String _getTargetLanguageEmoji(String language) {
    switch (language.toUpperCase()) {
      case 'EN':
        return '🇺🇸';
      case 'KO':
        return '🇰🇷';
      case 'JA':
        return '🇯🇵';
      case 'ZH':
        return '🇨🇳';
      case 'ES':
        return '🇪🇸';
      case 'FR':
        return '🇫🇷';
      case 'DE':
        return '🇩🇪';
      case 'IT':
        return '🇮🇹';
      case 'PT':
        return '🇵🇹';
      case 'RU':
        return '🇷🇺';
      default:
        return '';
    }
  }

  String _getPersonaImage(String persona) {
    switch (persona.toUpperCase()) {
      case 'ETHAN':
        return 'assets/icons/png/ethan.png';
      case 'LUNA':
        return 'assets/icons/png/luna.png';
      case 'KAI':
        return 'assets/icons/png/kai.png';
      case 'SORA':
        return 'assets/icons/png/sora.png';
      case 'NOAH':
        return 'assets/icons/png/noah.png';
      case 'ARIA':
        return 'assets/icons/png/aria.png';
      default:
        return 'assets/icons/png/noah.png';
    }
  }
}
