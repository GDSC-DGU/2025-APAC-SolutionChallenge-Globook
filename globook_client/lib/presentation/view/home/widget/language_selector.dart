import 'package:flutter/material.dart';

class LanguagePair {
  final String sourceLanguage;
  final String targetLanguage;

  const LanguagePair({
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}

class LanguageSelectorWidget extends StatelessWidget {
  final LanguagePair currentLanguages;
  final VoidCallback onPressed;

  const LanguageSelectorWidget({
    super.key,
    required this.currentLanguages,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 24),
              const SizedBox(width: 8),
              Text(
                currentLanguages.sourceLanguage,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                size: 16,
                color: Colors.black,
              ),
              const SizedBox(width: 8),
              Text(
                currentLanguages.targetLanguage,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
