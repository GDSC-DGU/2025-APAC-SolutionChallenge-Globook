import 'package:globook_client/core/usecase/base_usecase.dart';
import 'package:globook_client/domain/repository/auth/login_repository.dart';

class GoogleLoginUseCase extends BaseUseCase implements LoginRepository {
  @override
  Future<void> login(String email, String password) {
    // TODO: implement login
    return Future.value();
  }
}
