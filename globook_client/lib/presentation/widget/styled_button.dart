import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';

class StyledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget? icon;
  final Color? backgroundColor;
  final double? width; 

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = ColorSystem.highlight,
    this.icon,
    this.width, 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // if it is null, it will be the content width
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // 이거 꼭!
          children: [
            if (icon != null) icon!,
            if (icon != null) const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
