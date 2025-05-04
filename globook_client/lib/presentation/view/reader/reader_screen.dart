import 'package:flutter/material.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/presentation/view/reader/widget/reader_content.dart';
import 'package:globook_client/presentation/view_model/reader/reader_view_model.dart';
import 'package:globook_client/presentation/view/reader/widget/reader_app_bar.dart';
import 'package:globook_client/presentation/view/reader/widget/reader_bottom_bar.dart';

class ReaderScreen extends BaseScreen<ReaderViewModel> {
  const ReaderScreen({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const ReaderAppBar();
  }

  @override
  Widget buildBody(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReaderContent(),
        ReaderBottomBar(),
      ],
    );
  }
}
