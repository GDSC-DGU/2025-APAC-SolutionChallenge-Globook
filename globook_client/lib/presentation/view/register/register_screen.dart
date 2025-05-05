import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/presentation/view/login/widget/icon_text_field.dart';
import 'package:globook_client/presentation/view_model/register/register_view_model.dart';
import 'package:globook_client/presentation/widget/styled_button.dart';

class RegisterScreen extends BaseScreen<RegisterViewModel> {
  const RegisterScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Column(
        children: [
          const Text('Register',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          IconTextField(
            label: 'E-mail',
            hintText: 'Enter your email',
            icon: Icons.email,
            onChanged: (value) {
              viewModel.onChangedEmail(value);
            },
          ),
          const SizedBox(height: 20),
          IconTextField(
            label: 'Password',
            hintText: 'Enter your password',
            icon: Icons.lock,
            isPassword: true,
            onChanged: (value) {
              viewModel.onChangedPassword(value);
            },
          ),
          const SizedBox(height: 20),
          IconTextField(
            label: 'Password Check',
            hintText: 'Enter your password again',
            icon: Icons.lock,
            isPassword: true,
            onChanged: (value) {
              viewModel.onChangedPasswordCheck(value);
            },
          ),
          const SizedBox(height: 60),
          StyledButton(
            onPressed: () {
              viewModel.signup();
            },
            height: 60,
            borderRadius: 20,
            width: double.infinity,
            backgroundColor: ColorSystem.load2,
            text: 'Sign Up',
          ),
          const SizedBox(height: 20),
          StyledButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.LOGIN);
            },
            height: 60,
            borderRadius: 20,
            width: double.infinity,
            backgroundColor: ColorSystem.load1,
            text: 'Cancel',
          ),
        ],
      ),
    ));
  }
}
