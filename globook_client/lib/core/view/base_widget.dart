import 'package:flutter/material.dart';
import 'package:get/get.dart';

@immutable
abstract class BaseWidget<T extends GetxController> extends GetView<T> {
  const BaseWidget({super.key});

  /// Method to get the view model
  T get viewModel => controller;

  @override
  Widget build(BuildContext context) {
    return buildView(context);
  }

  /// Method that must be implemented by subclasses, this method should return the widget that actually constructs the screen
  Widget buildView(BuildContext context);
}
