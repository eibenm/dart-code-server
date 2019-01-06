import 'package:logging/logging.dart';

/// A base logging handler class that can be psassed into the 
/// logger.onRecord.listen() handler.
abstract class BaseLoggingHandler {
  void call(LogRecord logRecord);
}
