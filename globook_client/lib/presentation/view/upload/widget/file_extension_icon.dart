import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globook_client/domain/enum/Efile.dart';
import 'package:globook_client/domain/model/file.dart';

class FileExtensionIcon extends StatelessWidget {
  final UserFile file;

  const FileExtensionIcon({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Center(
        child: SvgPicture.asset(
          file.title.contains('.pdf')
              ? 'assets/icons/svg/pdf.svg'
              : 'assets/icons/svg/hwp.svg',
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
