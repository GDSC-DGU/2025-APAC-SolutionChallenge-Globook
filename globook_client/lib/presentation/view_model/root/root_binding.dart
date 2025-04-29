import 'package:get/get.dart';
import 'package:globook_client/presentation/view_model/home/home_view_model.dart';
import 'package:globook_client/presentation/view_model/login/login_view_model.dart';
import 'package:globook_client/presentation/view_model/root/root_view_model.dart';
import 'package:globook_client/presentation/view_model/upload/upload_view_model.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootViewModel>(() => RootViewModel());
    Get.lazyPut<LoginViewModel>(() => LoginViewModel());
    Get.lazyPut<HomeViewModel>(() => HomeViewModel());
    Get.lazyPut<UploadViewModel>(() => UploadViewModel());
  }
}
