import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/presentation/view/home/home_screen.dart';
import 'package:globook_client/presentation/view/login/login_screen.dart';
import 'package:globook_client/presentation/view/root/root_screen.dart';
import 'package:globook_client/presentation/view/splash/splash_screen.dart';

abstract class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.ROOT,
      page: () => const RootScreen(),
    ),
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
    ),
  ];
}
