library services.common_server;

import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

import 'api_classes.dart';
import 'analysis_server/analysis_server.dart';
import 'compiler.dart';
import 'pub.dart';
import 'sdk_manager.dart';

final Logger log = Logger('api_server');

/// Toggle to on to enable `package:` support.
final bool enablePackages = false;

@ApiClass(
  name: 'dartservices',
  version: 'v1',
  description: 'Dart services server API')
class DartServicesAPIServer {
  Pub pub;
  Compiler compiler;
  // AnalysisServerWrapper analysisServer;

  String sdkPath;

  DartServicesAPIServer(/*String this.sdkPath*/) {
    hierarchicalLoggingEnabled = true;
    log.level = Level.ALL;
  }

  Future init() async {
    pub = enablePackages ? Pub() : Pub.mock();
    compiler = Compiler(sdkPath, pub);
    // analysisServer = AnalysisServerWrapper(sdkPath);

    // await analysisServer.init();
    // analysisServer.onExit.then((int code) {
    //   log.severe('analysisServer exited, code: $code');
    //   if (code != 0) {
    //     exit(code);
    //   }
    // });

    return Future.value();
  }

  Future warmup({bool useHtml = false}) async {
    await compiler.warmup(useHtml: useHtml);
    // await analysisServer.warmup(useHtml: useHtml);
  }

  Future restart() async {
    log.warning('Restarting ApiServer');
    await shutdown();
    log.info('Analysis Servers shutdown');

    await init();
    await warmup();

    log.warning('Restart complete');
  }

  Future shutdown() {
    // return Future.wait([analysisServer.shutdown()]);
  }

  // ------- TEST APIS

  @ApiMethod(
      method: 'GET',
      path: 'version',
      description: 'Return the current SDK version for DartServices.')
  Future<VersionResponse> version() => Future.value(_version());

  VersionResponse _version() => VersionResponse(
      sdkVersion: SdkManager.sdk.version,
      sdkVersionFull: SdkManager.sdk.versionFull);

  // ---- Testing Methods

  @ApiMethod(
      method: 'GET',
      path: 'someMethod')
  MyResponse myMethod() {
    return MyResponse();
  }

  @ApiMethod(path: 'futureMethod')
  Future<MyResponse> myFutureMethod() {
    var completer = new Completer<MyResponse>();
    completer.complete(new MyResponse());
    return completer.future;
  }

  // ---- Done With Testing Methods
}

class MyResponse {
  String result;
}