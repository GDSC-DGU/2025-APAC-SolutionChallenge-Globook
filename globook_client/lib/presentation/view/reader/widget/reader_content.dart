import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_widget.dart';
import 'package:globook_client/presentation/view_model/reader/reader_view_model.dart';

class ReaderContent extends BaseWidget<ReaderViewModel> {
  const ReaderContent({super.key});

  @override
  Widget buildView(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Obx(() {
      final highlights = viewModel.highlights;
      final currentPlayingIndex = viewModel.currentPlayingIndex;

      // 현재 재생 중인 하이라이트가 변경될 때마다 스크롤 위치 조정
      if (currentPlayingIndex >= 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final double screenHeight = renderBox.size.height;
            final double targetPosition =
                currentPlayingIndex * 100.0; // 대략적인 높이 추정
            final double scrollTo = targetPosition - (screenHeight / 2);

            // 최상단이나 최하단이 아닌 경우에만 스크롤하게 해서 UX개선
            if (scrollTo > 0 &&
                scrollTo < scrollController.position.maxScrollExtent) {
              scrollController.animateTo(
                scrollTo,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          }
        });
      }

      return Expanded(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: highlights.map((highlight) {
                final isCurrent = currentPlayingIndex >= 0 &&
                    highlight.index == currentPlayingIndex;
                return Container(
                  key: ValueKey(highlight.index),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? viewModel.currentHighlightColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: InkWell(
                    onTap: () {
                      viewModel.playHighlight(highlight);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: MarkdownBody(
                        data: highlight.text,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            fontSize: viewModel.fontSize,
                            height: 1.5,
                            color: isCurrent
                                ? viewModel.currentTextColor
                                : ColorSystem.darkText,
                          ),
                          h1: TextStyle(
                            fontSize: viewModel.fontSize * 1.5,
                            fontWeight: FontWeight.bold,
                            color: isCurrent
                                ? viewModel.currentTextColor
                                : ColorSystem.darkText,
                          ),
                          h2: TextStyle(
                            fontSize: viewModel.fontSize * 1.3,
                            fontWeight: FontWeight.bold,
                            color: isCurrent
                                ? viewModel.currentTextColor
                                : ColorSystem.darkText,
                          ),
                          h3: TextStyle(
                            fontSize: viewModel.fontSize * 1.1,
                            fontWeight: FontWeight.bold,
                            color: isCurrent
                                ? viewModel.currentTextColor
                                : ColorSystem.darkText,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}
