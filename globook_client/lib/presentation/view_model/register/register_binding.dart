import 'package:get/get.dart';
import 'package:globook_client/presentation/view_model/register/register_view_model.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterViewModel>(() => RegisterViewModel());
  }
}
