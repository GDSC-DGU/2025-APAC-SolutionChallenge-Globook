import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/presentation/view_model/root/root_binding.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // RootBinding 실행으로 의존성 등록은 이미 main.dart에서 했으므로 주석 처리
    RootBinding().dependencies();

    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(AppRoutes.ROOT);
    });

    return Scaffold(
      body: Container(
        decoration: GradientSystem.gradient1,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/svg/main-logo.svg',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 24),
              const Text(
                'Innovation in Book Translation',
                style: TextStyle(
                  color: Color(0xFFA4B3DE),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
