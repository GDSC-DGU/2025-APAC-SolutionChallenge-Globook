import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:globook_client/app/config/app_routes.dart';
import 'package:globook_client/app/env/common/environment.dart';
import 'package:globook_client/app/env/common/environment_factory.dart';
import 'package:globook_client/app/utility/log_util.dart';
import 'package:globook_client/data/factory/storage_factory.dart';
import 'package:globook_client/data/provider/common/system_provider.dart';

abstract class BaseConnect extends GetConnect {
  static final GetHttpClient _customHttpClient = GetHttpClient();

  static final Environment _environment = EnvironmentFactory.environment;
  static final SystemProvider _systemProvider = StorageFactory.systemProvider;

  static const Map<String, String> unusedAuthorization = {
    "usedAuthorization": "false",
  };

  static const Map<String, String> usedAuthorization = {
    "usedAuthorization": "true",
  };

  @override
  void onInit() {
    super.onInit();

    httpClient
      ..baseUrl = _environment.apiServerUrl
      ..defaultContentType = 'application/json; charset=utf-8'
      ..timeout = const Duration(seconds: 10);

    httpClient.addRequestModifier<dynamic>((request) {
      // Create a copy of the headers
      final headers = Map<String, String>.from(request.headers);

      // Check login request
      if (request.url.toString().contains('/auth')) {
        LogUtil.info("🔑 Login request detected: ${request.url}");
        return request;
      }

      // Authorization
      String? usedAuthorization = headers["usedAuthorization"];

      if (usedAuthorization == "true") {
        headers["Authorization"] = "Bearer ${_systemProvider.getAccessToken()}";
      }

      debugPrint('current accessToken: ${_systemProvider.getAccessToken()}');

      // Splash Screen processing
      if (!headers.containsKey("usedInSplashScreen")) {
        headers["usedInSplashScreen"] = "false";
      }

      // Logging
      LogUtil.info(
        "🛫 [${request.method}] ${request.url} | START",
      );
      LogUtil.info("Headers: $headers");

      // Replace headers at once
      request.headers.clear();
      request.headers.addAll(headers);

      return request;
    });

    httpClient.addResponseModifier((request, Response response) async {
      if (response.status.hasError) {
        // Error response logging
        LogUtil.error(
          "🚨 [${request.method}] ${request.url} | END",
        );
        LogUtil.error(
          "Error: ${response.body['error']}",
        );

        await _isExpiredTokens(
          request: request,
          statusCodeOrErrorCode: response.body['error']['code'],
        );
      } else {
        LogUtil.info(
          "🛬 [${request.method}] ${request.url} | END ${response.body}",
        );
      }

      return response;
    });

    httpClient.addAuthenticator<dynamic>((request) async {
      if (request.url.toString().contains("login")) {
        return request;
      }

      Response reissueResponse = await _reissueToken();

      if (!reissueResponse.hasError) {
        await _systemProvider.allocateTokens(
          accessToken: reissueResponse.body['data']['accessToken'],
          refreshToken: reissueResponse.body['data']['refreshToken'],
        );
      } else {
        await _isExpiredTokens(
          request: request,
          statusCodeOrErrorCode: reissueResponse.statusCode!,
        );
      }

      return request;
    });

    httpClient.maxAuthRetries = 1;
  }

  Future<Response<dynamic>> _reissueToken() async {
    String refreshToken = _systemProvider.getRefreshToken();

    Response response;

    try {
      response = await _customHttpClient.post(
        "${_environment.apiServerUrl}/auth/reissue/token",
        contentType: 'application/json; charset=utf-8',
        headers: {
          "Authorization": "Bearer $refreshToken",
        },
      );
    } catch (e) {
      response = const Response(
        statusCode: 401,
      );
    }

    return response;
  }

  Future<void> _isExpiredTokens({
    required Request<dynamic> request,
    required int statusCodeOrErrorCode,
  }) async {
    String usedInSplashScreen = request.headers["usedInSplashScreen"]!;

    if ((statusCodeOrErrorCode == 401 || statusCodeOrErrorCode == 40402) &&
        usedInSplashScreen == 'false') {
      await StorageFactory.systemProvider.deallocateTokens();

      Get.snackbar(
        "로그인 만료",
        "로그인이 만료되었습니다. 다시 로그인해주세요.",
      );

      Get.offAllNamed(AppRoutes.ROOT);
    }
  }

  @protected
  String get accessToken => _systemProvider.getAccessToken();
}
