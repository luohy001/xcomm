import 'package:logger/logger.dart';

class Log {
  static final Log _instance = Log._internal();

  factory Log() {
    return _instance;
  }

  late Logger logger;

  Log._internal() {
    ConsoleOutput output = ConsoleOutput();
    logger = Logger(
      output: output,
      printer: PrettyPrinter(
        noBoxingByDefault: true,
        methodCount: 0,
        printEmojis: false,
      ),
    );
  }

  void i(String string) {
    logger.i(string);
  }

  void w(String string) {
    logger.w(string);
  }
}
