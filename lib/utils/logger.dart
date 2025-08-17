import 'dart:developer' as developer;

class Logger {
  static void d(String message, {String tag = 'DEBUG'}) {
    developer.log(message, name: tag);
  }

  static void i(String message, {String tag = 'INFO'}) {
    developer.log(message, name: tag);
  }

  static void w(String message, {String tag = 'WARNING'}) {
    developer.log(message, name: tag);
  }

  static void e(String message, {String tag = 'ERROR'}) {
    developer.log(message, name: tag);
  }
}
