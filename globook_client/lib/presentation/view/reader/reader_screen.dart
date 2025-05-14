import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/presentation/view/reader/widget/reader_content.dart';
import 'package:globook_client/presentation/view_model/home/home_view_model.dart';
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
    return WillPopScope(
      onWillPop: () async {
        LogUtil.debug('ReaderScreen: WillPopScope');
        final homeViewModel = Get.find<HomeViewModel>();
        await homeViewModel.loadBooks();
        return true;
      },
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReaderContent(),
          ReaderBottomBar(),
        ],
      ),
    );
  }
}
