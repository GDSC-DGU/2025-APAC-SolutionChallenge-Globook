import 'package:flutter/material.dart';

abstract class ColorSystem {
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const light = Color(0xFFE7ECFB);
  static const mainText = Color(0xFF333C55);
  static const lightText = Color(0xFF828282);
  static const logoText = Color(0xFFA4B3DE);
  static const line = Color(0xFFd7d7d7);
  static const bar = Color(0xFFF1F1F1);
  static const highlight = Color(0xFF003DE8);
  static const highlightDark = Color(0xFF18233C);
  static const background = Color(0xFFE7F3FF);
  static const load1 = Color(0xFF1B233C);
  static const load2 = Color(0xFF001F77);
}

abstract class GradientSystem {
  static BoxDecoration get gradient1 => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFFFFF),
            Color.fromARGB(255, 227, 233, 250),
          ],
        ),
      );
}
