import 'package:globook_client/data/model/repsonse_wrapper.dart';

abstract class AuthProvider {
  Future<ResponseWrapper<String>> login({
    required String email,
    required String password,
  });

  Future<ResponseWrapper<String>> signup({
    required String email,
    required String password,
    required String passwordConfirm,
  });

  Future<ResponseWrapper<String>> signInAtGoogle();
  Future<ResponseWrapper<String>> signInWithGoogle(String accessToken);
}
