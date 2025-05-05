// import 'package:envied/envied.dart';
import 'package:envied/envied.dart';
import 'package:globook_client/app/env/common/environment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'dev_environment.g.dart';

@Envied(path: 'assets/config/.dev.env')
class DevEnvironment implements Environment {
  @EnviedField(varName: 'API_SERVER_URL')
  static String get API_SERVER_URL =>
      dotenv.env['API_SERVER_URL'] ?? 'https://your-server-url.com';

  @override
  String get apiServerUrl => API_SERVER_URL;
}
