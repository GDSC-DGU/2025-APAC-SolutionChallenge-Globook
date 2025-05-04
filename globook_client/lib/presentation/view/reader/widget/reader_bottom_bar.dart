import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_widget.dart';
import 'package:globook_client/presentation/view_model/reader/reader_view_model.dart';
import 'package:globook_client/presentation/widget/styled_button.dart';

class ReaderBottomBar extends BaseWidget<ReaderViewModel> {
  const ReaderBottomBar({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(() => LinearProgressIndicator(
                  value: viewModel.readingProgress,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      ColorSystem.highlight),
                  minHeight: 3,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => Text(
                  viewModel.playStatus,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: () {
                  viewModel.playPreviousHighlight();
                },
              ),
              Obx(() => StyledButton(
                    width: 150,
                    onPressed: () {
                      if (viewModel.isPlaying) {
                        viewModel.pauseTTS();
                      } else {
                        viewModel.playTTS();
                      }
                    },
                    icon: Icon(viewModel.isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle),
                    text: viewModel.isPlaying ? '일시정지' : '재생',
                    backgroundColor: ColorSystem.highlight,
                  )),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: () {
                  viewModel.playNextHighlight();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
