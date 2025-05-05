import 'package:get/get.dart';
import 'package:globook_client/core/usecase/base_usecase.dart';
import 'package:globook_client/data/repository/auth/login_repository.dart';

class LoginUseCase extends BaseUseCase implements LoginRepository {
  late final LoginRepository _loginRepository;

  @override
  void onInit() {
    super.onInit();
    _loginRepository = Get.find<LoginRepository>();
  }

  @override
  Future<void> login(String email, String password) {
    return _loginRepository.login(email, password);
  }

  @override
  Future<void> signup(String email, String password, String passwordCheck) {
    return _loginRepository.signup(email, password, passwordCheck);
  }
}
