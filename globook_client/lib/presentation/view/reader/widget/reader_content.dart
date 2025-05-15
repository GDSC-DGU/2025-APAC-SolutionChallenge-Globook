import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/core/view/base_widget.dart';
import 'package:globook_client/presentation/view_model/reader/reader_view_model.dart';

class ReaderContent extends BaseWidget<ReaderViewModel> {
  const ReaderContent({super.key});

  @override
  Widget buildView(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final Map<int, GlobalKey> highlightKeys = {};
    bool isPaginationInProgress = false;

    void scrollToHighlight(int index) {
      if (viewModel.isLoadingMore || isPaginationInProgress) return;

      // if the scroll position is at the top, do not scroll
      if (scrollController.position.pixels == 0) return;

      // Find the actual DB index corresponding to the highlight
      final highlightIndex =
          viewModel.highlights.indexWhere((h) => h.index == index);
      if (highlightIndex == -1) return;

      final currentKey = highlightKeys[highlightIndex];
      if (currentKey?.currentContext != null) {
        Scrollable.ensureVisible(
          currentKey!.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      }
    }

    LogUtil.debug(viewModel.currentParagraphsInfo);

    return Obx(() {
      final highlights = viewModel.highlights;
      final currentPlayingIndex = viewModel.currentPlayingIndex;
      final isLoadingMore = viewModel.isLoadingMore;

      // Update Pagenation State
      if (isLoadingMore) {
        isPaginationInProgress = true;
      } else {
        // After pagination is complete, wait a little and reset the state
        Future.delayed(const Duration(milliseconds: 500), () {
          isPaginationInProgress = false;
        });
      }

      // When the currently playing highlight changes, adjust the scroll position
      if (currentPlayingIndex >= 0 &&
          !isLoadingMore &&
          !isPaginationInProgress) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToHighlight(currentPlayingIndex);
        });
      }

      return Expanded(
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification && !isLoadingMore) {
                  final maxScroll = scrollInfo.metrics.maxScrollExtent;
                  final currentScroll = scrollInfo.metrics.pixels;
                  final screenHeight = MediaQuery.of(context).size.height;
                  viewModel.onScroll(maxScroll, currentScroll, screenHeight);
                }
                return true;
              },
              child: SingleChildScrollView(
                controller: scrollController,
                physics: isLoadingMore
                    ? const NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: highlights.asMap().entries.map((entry) {
                      final highlightIndex = entry.key;
                      final highlight = entry.value;
                      final isCurrent = currentPlayingIndex >= 0 &&
                          highlight.index == currentPlayingIndex;

                      // Create and save a GlobalKey for each highlight
                      if (!highlightKeys.containsKey(highlightIndex)) {
                        highlightKeys[highlightIndex] = GlobalKey();
                      }

                      return Container(
                        key: highlightKeys[highlightIndex],
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? viewModel.currentHighlightColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: InkWell(
                          onTap: () {
                            if (!isLoadingMore) {
                              // Only process tap events when not loading
                              LogUtil.debug(
                                  'Tap event processing: highlight.index: ${highlight.index}');
                              viewModel.playHighlight(highlight);
                            }
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
            ),
            if (isLoadingMore)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      );
    });
  }
}
