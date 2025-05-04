import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:globook_client/core/view/base_widget.dart';
import 'package:globook_client/presentation/view_model/reader/reader_view_model.dart';

class ReaderAppBar extends BaseWidget<ReaderViewModel>
    implements PreferredSizeWidget {
  const ReaderAppBar({super.key});

  @override
  Widget buildView(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '${viewModel.currentBook?.title}',
        style: const TextStyle(color: Colors.black),
      ),
      actions: [
        GestureDetector(
          onTapUp: (details) {
            _showHighlightColorPicker(context);
          },
          child: SvgPicture.asset(
            'assets/icons/svg/highlight.svg',
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTapUp: (details) {
            _showFontSizePopup(context, details.globalPosition);
          },
          child: SvgPicture.asset(
            'assets/icons/svg/font-size.svg',
            width: 19,
            height: 19,
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTapUp: (details) {
            _showTextColorPicker(context);
          },
          child: SvgPicture.asset(
            'assets/icons/svg/font.svg',
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _showFontSizePopup(BuildContext context, Offset offset) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(offset, offset),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('font size'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (viewModel.fontSize > 12) {
                          viewModel.setFontSize(viewModel.fontSize - 2);
                        }
                      },
                    ),
                    Text('${viewModel.fontSize.toInt()}'),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        if (viewModel.fontSize < 24) {
                          viewModel.setFontSize(viewModel.fontSize + 2);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _showHighlightColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('형광펜 색상 선택'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: viewModel.currentHighlightColor,
            onColorChanged: (color) {
              viewModel.setHighlightColor(color);
            },
          ),
        ),
      ),
    );
  }

  void _showTextColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('텍스트 색상 선택'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: viewModel.currentTextColor,
            onColorChanged: (color) {
              viewModel.setCurrentTextColor(color);
            },
          ),
        ),
      ),
    );
  }
}
