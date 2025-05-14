import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/core/view/base_widget.dart';
import 'package:globook_client/presentation/view_model/home/home_view_model.dart';
import 'package:globook_client/presentation/view_model/reader/reader_view_model.dart';
import 'dart:async';

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
        onPressed: () async {
          LogUtil.debug('ReaderAppBar: onPressed');
          final homeViewModel = Get.find<HomeViewModel>();
          await homeViewModel.loadBooks();
          Navigator.pop(context);
        },
      ),
      title: Text(viewModel.currentParagraphsInfo?.title ?? ''),
      actions: [
        GestureDetector(
          onTapUp: (details) {
            _showReadingSpeedPicker(context);
          },
          child: SvgPicture.asset(
            'assets/icons/svg/reading_speed.svg',
            width: 18,
            height: 18,
          ),
        ),
        const SizedBox(width: 16),
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
            _showTextSettingsDialog(context);
          },
          child: SvgPicture.asset(
            'assets/icons/svg/new-font.svg',
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

  void _showTextSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Text Settings'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Font Size',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (viewModel.fontSize > 12) {
                          viewModel.setFontSize(viewModel.fontSize - 2);
                        }
                      },
                    ),
                    Text(
                      '${viewModel.fontSize.toInt()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
              ),
              const SizedBox(height: 24),
              const Text(
                'Text Color',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ColorPicker(
                pickerColor: viewModel.currentTextColor,
                onColorChanged: (color) {
                  viewModel.setCurrentTextColor(color);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showHighlightColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Highlight Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: viewModel.currentHighlightColor,
            onColorChanged: (color) {
              viewModel.setHighlightColor(color);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showReadingSpeedPicker(BuildContext context) {
    Timer? debouncer;
    final RxDouble currentSpeed = viewModel.readingSpeed.obs;

    showDialog(
      context: context,
      builder: (context) => Obx(
        () => AlertDialog(
          title: const Text('Reading Speed'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  value: currentSpeed.value,
                  onChanged: (value) {
                    currentSpeed.value = value;
                    debouncer?.cancel();
                    debouncer = Timer(const Duration(milliseconds: 300), () {
                      viewModel.setReadingSpeed(value);
                    });
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  '${currentSpeed.value.toStringAsFixed(1)}x',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                debouncer?.cancel();
                viewModel.setReadingSpeed(currentSpeed.value);
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    ).then((_) {
      debouncer?.cancel();
    });
  }
}
