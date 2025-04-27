import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/color_system.dart';

@immutable
abstract class BaseScreen<T extends GetxController> extends GetView<T> {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!viewModel.initialized) {
      initViewModel();
    }

    return _buildBaseContainer(context);
  }

  Widget _buildBaseContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: unSafeAreaColor,
      ),
      child: wrapWithInnerSafeArea
          ? SafeArea(
              top: setTopOuterSafeArea,
              bottom: setBottomOuterSafeArea,
              child: _buildScaffold(context),
            )
          : _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      extendBody: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: screenBackgroundColor,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: buildFloatingActionButton,
      appBar: buildAppBar(context),
      body: wrapWithInnerSafeArea
          ? SafeArea(
              top: setTopInnerSafeArea,
              bottom: setBottomInnerSafeArea,
              child: buildBody(context),
            )
          : buildBody(context),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  /// Method to initialize the view model
  @protected
  void initViewModel() {
    viewModel.initialized;
  }

  /// Method to get the view model
  @protected
  T get viewModel => controller;

  /// Method to define the color of SafeArea
  @protected
  Color? get unSafeAreaColor => Colors.white;

  /// Method to define whether to adjust the screen when the keyboard appears
  @protected
  bool get resizeToAvoidBottomInset => true;

  /// Method to configure the Floating Action Button
  @protected
  Widget? get buildFloatingActionButton => null;

  /// Method to define the position of the Floating Action Button
  @protected
  FloatingActionButtonLocation? get floatingActionButtonLocation => null;

  /// Method to configure the AppBar
  @protected
  bool get extendBodyBehindAppBar => false;

  /// Method to define the background color of the screen
  @protected
  Color? get screenBackgroundColor => ColorSystem.white;

  /// Method to define whether to wrap the outside of Scaffold with SafeArea
  @protected
  bool get wrapWithOuterSafeArea => false;

  /// Method to define whether to set the top part of the outer SafeArea
  @protected
  bool get setTopOuterSafeArea => throw UnimplementedError();

  /// Method to define whether to set the bottom part of the outer SafeArea
  @protected
  bool get setBottomOuterSafeArea => throw UnimplementedError();

  /// Method to define whether to wrap the Scaffold Body with SafeArea
  @protected
  bool get wrapWithInnerSafeArea => false;

  /// Method to define whether to set the top part of the inner SafeArea
  @protected
  bool get setTopInnerSafeArea => throw UnimplementedError();

  /// Method to define whether to set the bottom part of the inner SafeArea
  @protected
  bool get setBottomInnerSafeArea => throw UnimplementedError();

  /// Method to configure the AppBar
  @protected
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  /// Method to configure the body of the screen, which must be implemented by subclasses
  @protected
  Widget buildBody(BuildContext context);

  /// Method to define whether to apply gradient to the screen background color
  bool get useGradientBackground => true;

  /// Method to configure the BottomNavigationBar
  @protected
  Widget? buildBottomNavigationBar(BuildContext context) => null;
}
