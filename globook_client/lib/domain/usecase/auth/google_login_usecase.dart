import 'package:get/get.dart';
import 'package:globook_client/core/usecase/base_usecase.dart';
import 'package:globook_client/data/repository/auth/google_login_repository.dart';

class GoogleLoginUseCase extends BaseUseCase implements GoogleLoginRepository {
  late final GoogleLoginRepository _googleLoginRepository;

  @override
  void onInit() {
    super.onInit();
    _googleLoginRepository = Get.find<GoogleLoginRepository>();
  }

  @override
  Future<void> signInWithGoogle() {
    return _googleLoginRepository.signInWithGoogle();
  }
}
