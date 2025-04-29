import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/app_pages.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/presentation/view/login/login_screen.dart';
import 'package:globook_client/presentation/view/splash/splash_screen.dart';
import 'package:globook_client/presentation/view/root/root_screen.dart';
import 'package:globook_client/presentation/view_model/root/root_binding.dart';

void main() {
  // Flutter Engine Reset
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency Injection
  RootBinding().dependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Globook',
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.pages,
    );
  }
}
