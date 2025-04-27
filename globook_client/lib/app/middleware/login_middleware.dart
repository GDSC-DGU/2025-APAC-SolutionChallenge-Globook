import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/data/factory/storage_factory.dart';

class LoginMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    bool isNotLogin = !StorageFactory.systemProvider.isLogin;

    if (isNotLogin) {
      return const RouteSettings(name: AppRoutes.LOGIN);
    }

    return null;
  }
}
