import 'dart:core';
import 'package:get/get.dart';
import 'package:globook_client/domain/usecase/auth/google_login_usecase.dart';
import 'package:globook_client/domain/usecase/auth/login_usecase.dart';

class LoginViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */

  /* -----------Dependeny Injection of UseCase------------- */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final LoginUseCase _loginUseCase;
  late final GoogleLoginUseCase _googleLoginUseCase;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  late final RxString _email = RxString('');
  late final RxString _password = RxString('');
  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  // DateTime get currentAt => _currentAt.value;
  String get email => _email.value;
  String get password => _password.value;

  @override
  void onInit() async {
    super.onInit();
    // Dependency Injection
    _loginUseCase = Get.find<LoginUseCase>();
    _googleLoginUseCase = Get.find<GoogleLoginUseCase>();
  }

  void onChangedEmail(String email) {
    _email.value = email;
  }

  void onChangedPassword(String password) {
    _password.value = password;
  }

  void login() async {
    await _loginUseCase.login(email, password);
  }

  void signInWithGoogle() async {
    await _googleLoginUseCase.signInWithGoogle();
  }
}
