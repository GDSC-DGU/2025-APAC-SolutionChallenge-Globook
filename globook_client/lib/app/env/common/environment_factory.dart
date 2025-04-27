import 'package:globook_client/app/env/common/environment.dart';
import 'package:globook_client/app/env/dev/dev_environment.dart';

abstract class EnvironmentFactory {
  static Environment? _environment;

  static Environment get environment => EnvironmentFactory._environment!;

  // static Future<void> onInit() async {
  //   _environment = DevEnvironment();
  // }
}
