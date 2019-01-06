library services;

import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';

import 'src/endpoints_server.dart';
import 'src/logging/file_logging_handler.dart';
import 'src/logging/terminal_logging_handler.dart';
import 'src/sdk_manager.dart';

Logger _logger = Logger('services');

void main(List<String> args) {
  var parser = ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8082')
    ..addOption('server-url', defaultsTo: 'http://localhost');

  var result = parser.parse(args);
  var port = int.tryParse(result['port']);
  if (port == null) {
    stdout.writeln(
        'Could not parse port value "${result['port']}" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(new FileLoggingHandler('log/dartservices.log'));
  if (stdout.hasTerminal) {
    Logger.root.onRecord.listen(new TerminalLoggingHandler());
  }

  EndpointsServer.serve(SdkManager.sdk.sdkPath, port).then((EndpointsServer server) {
    _logger.info('Listening on port ${server.port}');
  });
}
