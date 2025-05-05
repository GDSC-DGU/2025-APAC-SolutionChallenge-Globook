import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/data/factory/storage_factory.dart';
import 'package:globook_client/data/provider/auth/auth_provider.dart';
import 'package:globook_client/data/repository/auth/google_login_repository.dart';

class GoogleLoginRepositoryImpl extends GetxService
    implements GoogleLoginRepository {
  late final AuthProvider _authProvider;

  @override
  void onInit() {
    super.onInit();
    _authProvider = Get.find<AuthProvider>();
  }

  @override
  Future<void> signInWithGoogle() async {
    final response = await _authProvider.signInAtGoogle();
    if (response.success) {
      final finalResponse =
          await _authProvider.signInWithGoogle(response.data!);
      LogUtil.info(finalResponse);
      if (finalResponse.success) {
        await StorageFactory.systemProvider.setAccessToken(finalResponse.data!);
        await Get.offNamed(AppRoutes.ROOT);
      }
    }
  }
}
