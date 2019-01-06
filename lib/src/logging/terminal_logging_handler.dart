import 'package:logging/logging.dart';

import 'base_logging_handler.dart';

class TerminalLoggingHandler implements BaseLoggingHandler {

  void call(LogRecord logRecord) {
    print(logRecord);
    if (logRecord.stackTrace != null) {
      print(logRecord.stackTrace);
    }
  }  
}
