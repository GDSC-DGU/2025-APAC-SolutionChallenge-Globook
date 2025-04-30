import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets contentPadding;

  const SearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.height = 50,
    this.backgroundColor = const Color(0xFFF1F1F1),
    this.textColor = ColorSystem.lightText,
    this.borderRadius = 4,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: textColor,
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search, color: textColor),
          border: InputBorder.none,
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}
