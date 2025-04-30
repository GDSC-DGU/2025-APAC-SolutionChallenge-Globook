import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globook_client/data/provider/common/system_provider.dart';

class SystemProviderImpl implements SystemProvider {
  SystemProviderImpl({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;

  String? _accessToken;
  String? _refreshToken;
  String? _fcmToken;

  /* ------------------------------------------------------------ */
  /* Initialize ------------------------------------------------- */
  /* ------------------------------------------------------------ */
  @override
  Future<void> onInit() async {
    _accessToken = await _secureStorage.read(
      key: SystemProviderExt.accessToken,
    );
    _refreshToken = await _secureStorage.read(
      key: SystemProviderExt.refreshToken,
    );
    _fcmToken = await _secureStorage.read(
      key: SystemProviderExt.fcmToken,
    );
  }

  @override
  Future<void> allocateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.write(
      key: SystemProviderExt.accessToken,
      value: accessToken,
    );
    await _secureStorage.write(
      key: SystemProviderExt.refreshToken,
      value: refreshToken,
    );

    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  @override
  Future<void> deallocateTokens() async {
    await _secureStorage.delete(key: SystemProviderExt.accessToken);
    await _secureStorage.delete(key: SystemProviderExt.refreshToken);
    await _secureStorage.delete(key: SystemProviderExt.fcmToken);

    _accessToken = null;
    _refreshToken = null;
    _fcmToken = null;
  }

  /* ------------------------------------------------------------ */
  /* Default ---------------------------------------------------- */
  /* ------------------------------------------------------------ */
  @override
  bool get isLogin => _accessToken != null && _refreshToken != null;

  /* ------------------------------------------------------------ */
  /* Getter ----------------------------------------------------- */
  /* ------------------------------------------------------------ */
  @override
  String getAccessToken() {
    return _accessToken!;
  }

  @override
  String getRefreshToken() {
    return _refreshToken!;
  }

  @override
  String? getFCMToken() {
    return _fcmToken;
  }

  /* ------------------------------------------------------------ */
  /* Setter ----------------------------------------------------- */
  /* ------------------------------------------------------------ */

  @override
  Future<void> setAccessToken(String accessToken) async {
    await _secureStorage.write(
      key: SystemProviderExt.accessToken,
      value: accessToken,
    );

    _accessToken = accessToken;
  }

  @override
  Future<void> setRefreshToken(String refreshToken) async {
    await _secureStorage.write(
      key: SystemProviderExt.refreshToken,
      value: refreshToken,
    );

    _refreshToken = refreshToken;
  }

  @override
  Future<void> setFCMToken(String token) async {
    await _secureStorage.write(
      key: SystemProviderExt.fcmToken,
      value: token,
    );

    _fcmToken = token;
  }
}
