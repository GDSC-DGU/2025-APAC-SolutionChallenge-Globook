import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globook_client/data/provider/common/system_provider.dart';
import 'package:globook_client/data/provider/common/system_provider_impl.dart';

class StorageFactory {
  static late final FlutterSecureStorage _secureStorage;

  static SystemProvider? _systemProvider;

  static SystemProvider get systemProvider => _systemProvider!;

  static Future<void> onInit() async {
    _secureStorage = const FlutterSecureStorage();
  }

  static Future<void> onReady() async {
    _systemProvider = SystemProviderImpl(
      secureStorage: _secureStorage,
    );

    await _systemProvider!.onInit();
  }
}
