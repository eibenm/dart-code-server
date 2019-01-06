import 'dart:io';

import 'package:logging/logging.dart';

import 'base_logging_handler.dart';

class FileLoggingHandler implements BaseLoggingHandler {
  
  final String filename;
  final File _file;
  
  FileLoggingHandler(String this.filename) :
    _file = new File(filename);
  
  void call(LogRecord logRecord) {
    IOSink sink = _file.openWrite(mode: FileMode.append);
    sink.write('${new DateTime.now()}\n');
    sink.write('${logRecord}\n\n');
    sink.close();
  }  
}
