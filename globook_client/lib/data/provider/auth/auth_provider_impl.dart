import 'package:get/get.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/data/provider/auth/auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProviderImpl extends BaseConnect implements AuthProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  @override
  Future<ResponseWrapper<String>> login({
    required String email,
    required String password,
  }) async {
    final response = await post('/api/v1/auth/sign-in', {
      'email': email,
      'password': password,
    });
    LogUtil.info(response);
    if (response.body is Map) {
      final token = response.body['data']['accessToken'];
      if (token != null) {
        return ResponseWrapper(success: true, data: token.toString());
      }
    }
    return ResponseWrapper(success: false, message: '토큰이 없습니다.');
  }

  @override
  Future<ResponseWrapper<String>> signup({
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    final response = await post('/api/v1/auth/sign-up', {
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
    });
    LogUtil.info(response);
    // response.body가 Map인 경우를 처리
    final accessToken = response.body['data']['accessToken'];
    if (accessToken != null) {
      return ResponseWrapper(success: true, data: accessToken.toString());
    }
    return ResponseWrapper(success: false, message: '토큰이 없습니다.');
  }

  @override
  Future<ResponseWrapper<String>> signInAtGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        return ResponseWrapper(success: false, message: '구글 로그인이 취소되었습니다.');
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? accessToken = auth.accessToken;
      if (accessToken == null) {
        return ResponseWrapper(
            success: false, message: '구글 액세스 토큰을 가져오는데 실패했습니다.');
      }

      LogUtil.info(accessToken);
      //success case
      return ResponseWrapper(success: true, data: accessToken);
    } catch (e) {
      return ResponseWrapper(
          success: false, message: '구글 로그인 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<ResponseWrapper<String>> signInWithGoogle(String accessToken) async {
    final response = await post('/api/v1/auth/sign-in/google', {}, headers: {
      'Authorization': 'Bearer $accessToken',
    });
    LogUtil.info(response);

    // 토큰이나 필요한 데이터를 추출
    final token = response.body['data']['accessToken'];
    if (token != null) {
      return ResponseWrapper(success: true, data: token.toString());
    }

    // Map이 아닌 경우 문자열로 변환
    return ResponseWrapper(success: true, data: response.body.toString());
  }
}
