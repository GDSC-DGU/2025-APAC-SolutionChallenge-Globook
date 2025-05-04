import 'package:get/get.dart';
import 'package:globook_client/domain/usecase/auth/login_usecase.dart';

class RegisterViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */

  /* -----------Dependeny Injection of UseCase------------- */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final LoginUseCase _loginUseCase;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  late final RxString _email = RxString('');
  late final RxString _password = RxString('');
  late final RxString _passwordCheck = RxString('');
  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  // DateTime get currentAt => _currentAt.value;
  String get email => _email.value;
  String get password => _password.value;
  String get passwordCheck => _passwordCheck.value;

  @override
  void onInit() async {
    super.onInit();
    // Dependency Injection
    _loginUseCase = Get.find<LoginUseCase>();
  }

  void onChangedEmail(String email) {
    _email.value = email;
  }

  void onChangedPassword(String password) {
    _password.value = password;
  }

  void onChangedPasswordCheck(String passwordCheck) {
    _passwordCheck.value = passwordCheck;
  }

  void signup() async {
    await _loginUseCase.signup(email, password);
  }
}
