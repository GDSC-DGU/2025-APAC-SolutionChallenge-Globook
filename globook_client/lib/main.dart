import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:globook_client/app/config/app_dependency.dart';
import 'package:globook_client/app/config/app_pages.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/app/env/common/environment_factory.dart';
import 'package:globook_client/data/factory/storage_factory.dart';
import 'package:globook_client/presentation/view_model/root/root_binding.dart';

void main() async {
  // Flutter Engine Reset
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: "assets/config/.dev.env");

  // Initialize Environment
  await EnvironmentFactory.onInit();

  // Storage Factory 초기화 추가
  await StorageFactory.onInit();
  await StorageFactory.onReady();

  // Dependency Injection
  RootBinding().dependencies();
  AppDependency().dependencies();

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
