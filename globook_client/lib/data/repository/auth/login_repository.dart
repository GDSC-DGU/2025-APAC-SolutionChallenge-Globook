abstract class LoginRepository {
  Future<void> login(String email, String password);
  Future<void> signup(String email, String password, String passwordConfirm);
}
