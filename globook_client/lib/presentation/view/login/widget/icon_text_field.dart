import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';

class IconTextField extends StatefulWidget {
  const IconTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.onChanged,
  });

  final String label;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final Function(String)? onChanged;

  @override
  State<IconTextField> createState() => _IconTextFieldState();
}

class _IconTextFieldState extends State<IconTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(color: ColorSystem.lightText)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: ColorSystem.light,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle:
                  const TextStyle(color: ColorSystem.lightText, fontSize: 13),
              icon: Icon(widget.icon, color: ColorSystem.lightText, size: 24),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: ColorSystem.lightText,
                      ),
                    )
                  : null,
            ),
            onChanged: widget.onChanged,
            obscureText: widget.isPassword ? _obscureText : false,
            keyboardType:
                widget.isPassword ? TextInputType.visiblePassword : null,
          ),
        ),
      ],
    );
  }
}
