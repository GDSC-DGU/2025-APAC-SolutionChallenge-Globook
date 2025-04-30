import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/core/view/base_screen.dart';
import 'package:globook_client/presentation/view/login/widget/icon_text_field.dart';
import 'package:globook_client/presentation/view_model/login/login_view_model.dart';
import 'package:globook_client/presentation/widget/styled_button.dart';

class LoginScreen extends BaseScreen<LoginViewModel> {
  const LoginScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Column(
        children: [
          const Text('Login',
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
          StyledButton(
            onPressed: () {
              viewModel.login();
            },
            height: 60,
            borderRadius: 20,
            width: double.infinity,
            text: 'Login',
          ),
          const SizedBox(height: 20),
          StyledButton(
              onPressed: () {
                viewModel.login();
              },
              height: 60,
              borderRadius: 20,
              width: double.infinity,
              text: 'Sign Up',
              backgroundColor: ColorSystem.load2),
          const SizedBox(height: 20),
          StyledButton(
            onPressed: () {
              viewModel.login();
            },
            width: double.infinity,
            height: 60,
            borderRadius: 20,
            icon: SvgPicture.asset('assets/icons/svg/google-logo.svg',
                width: 24, height: 24),
            text: 'Login with Google',
            backgroundColor: ColorSystem.highlightDark,
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    ));
  }
}
