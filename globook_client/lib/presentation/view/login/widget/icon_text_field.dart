import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_widget.dart';

class IconTextField extends BaseWidget {
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
  Widget buildView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: ColorSystem.lightText)),
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
              hintText: hintText,
              hintStyle:
                  const TextStyle(color: ColorSystem.lightText, fontSize: 13),
              icon: Icon(icon, color: ColorSystem.lightText, size: 24),
              suffixIcon: isPassword
                  ? IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility),
                    )
                  : null,
            ),
            onChanged: onChanged,
            obscureText: isPassword,
            keyboardType: isPassword ? TextInputType.visiblePassword : null,
          ),
        ),
      ],
    );
  }
}
