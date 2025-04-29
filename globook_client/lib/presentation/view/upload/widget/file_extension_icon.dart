import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globook_client/app/config/color_system.dart';

class FileExtensionIcon extends StatelessWidget {
  final Map<String, dynamic> file;

  const FileExtensionIcon({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        color: ColorSystem.light,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: SvgPicture.asset(
          file['fileType'] == 'pdf'
              ? 'assets/icons/svg/pdf.svg'
              : 'assets/icons/svg/hwp.svg',
          width: 32,
          height: 32,
        ),
      ),
    );
  }
}
