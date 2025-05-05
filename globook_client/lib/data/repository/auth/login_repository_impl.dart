import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/data/factory/storage_factory.dart';
import 'package:globook_client/data/provider/auth/auth_provider.dart';
import 'package:globook_client/data/repository/auth/login_repository.dart';

class LoginRepositoryImpl extends GetxService implements LoginRepository {
  late final AuthProvider _authProvider;
  @override
  void onInit() {
    super.onInit();
    _authProvider = Get.find<AuthProvider>();
  }

  @override
  Future<void> login(String email, String password) async {
    final response = await _authProvider.login(
      email: email,
      password: password,
    );
    if (response.success) {
      await StorageFactory.systemProvider.allocateTokens(
        accessToken: response.data ?? '',
      );
      Get.offNamed(AppRoutes.ROOT);
    }
  }

  @override
  Future<void> signup(
      String email, String password, String passwordConfirm) async {
    if (password != passwordConfirm) {
      throw Exception('비밀번호가 일치하지 않습니다.');
    }
    final response = await _authProvider.signup(
      email: email,
      password: password,
      passwordConfirm: passwordConfirm,
    );
    if (response.success) {
      Get.offNamed(AppRoutes.LOGIN);
    }
  }
}
