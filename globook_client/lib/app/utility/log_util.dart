import 'package:logger/logger.dart';

abstract class LogUtil {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  /// Info log
  static void info(dynamic message) {
    _logger.i(message);
  }

  /// Debug log
  static void debug(dynamic message) {
    _logger.d(message);
  }

  /// Error log
  static void error(dynamic message) {
    _logger.e(message);
  }

  // Print JSON data type
  static void printJsonDataType(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (value is List) {
        print('Key: $key, Type: List, Length: ${value.length}');
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            print('  $key List item is Map:');
            printJsonDataType(item);
          } else {
            print('  $key List item type: ${item.runtimeType}');
          }
        }
      } else if (value is Map<String, dynamic>) {
        print('Key: $key, Type: Map');
        printJsonDataType(value);
      } else {
        print('Key: $key, Type: ${value.runtimeType}');
      }
    });
  }
}
