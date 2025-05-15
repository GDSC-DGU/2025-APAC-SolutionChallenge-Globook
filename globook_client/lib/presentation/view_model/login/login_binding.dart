import 'package:get/get.dart';
import 'package:globook_client/domain/usecase/auth/login_usecase.dart';
import 'package:globook_client/domain/usecase/auth/google_login_usecase.dart';
import 'package:globook_client/presentation/view_model/login/login_view_model.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginUseCase>(() => LoginUseCase());
    Get.lazyPut<GoogleLoginUseCase>(() => GoogleLoginUseCase());
    Get.lazyPut<LoginViewModel>(() => LoginViewModel());
  }
}
