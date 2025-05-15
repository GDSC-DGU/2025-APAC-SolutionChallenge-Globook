import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final Color? textColor;
  final double? fontSize;
  final double? borderRadius;
  final bool isDisabled;
  final EdgeInsetsGeometry? padding;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = ColorSystem.highlight,
    this.icon,
    this.width,
    this.height,
    this.textColor,
    this.fontSize,
    this.borderRadius = 8,
    this.isDisabled = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor ?? Colors.white,
          disabledBackgroundColor: backgroundColor?.withOpacity(0.5),
          disabledForegroundColor:
              textColor?.withOpacity(0.5) ?? Colors.white.withOpacity(0.5),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
