library services.analysis_server;

import 'dart:async';
import 'dart:io';

import 'package:analysis_server_lib/analysis_server_lib.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

import '../api_classes.dart' as api;
import '../common.dart';
import '../pub.dart';

final Logger _logger = Logger('analysis_server');

/// Flag to determine whether we should dump the communication with the server to stdout.
bool dumpServerMessages = false;

// Use very long timeouts to ensure that the server has enough time to restart.
final Duration _ANALYSIS_SERVER_TIMEOUT = Duration(seconds: 35);

class AnalysisServerWrapper {

  final String _sdkPath;
  Future _init;
  Directory sourceDirectory;
  String mainPath;

  /// Instance to handle communication with the server.
  AnalysisServer analysisServer;

  Map<String, Completer<CompletionResults>> _analysisResultsCompleters = {};
  List<Completer> _analysisStatusCompleters = [];
  Map<String, List<AnalysisError>> _analysisErrors = {};

  // Stream subscriptions
  StreamSubscription onResultsStreamSubscription;
  StreamSubscription onStatusStreamSubscription;
  StreamSubscription onErrorsStreamSubscription;

  AnalysisServerWrapper(this._sdkPath) {
    sourceDirectory = Directory.systemTemp.createTempSync('analysisServer');
    mainPath = _getPathFromName(kMainDart);
  }

  Future init() {
    if (_init == null) {
      List<String> serverArgs = [
        '--preview-dart-2',
        '--dartcodeserver',
        '--client-id=DartCodeServer',
        '--client-version=${_sdkVersion}'
      ];

      _logger.info('About to start with server with args: ${serverArgs}');

      _init = AnalysisServer.create(
        onRead: _onRead,
        onWrite: _onWrite,
        sdkPath: _sdkPath,
        serverArgs: serverArgs,
      ).then((AnalysisServer server) async {
        analysisServer = server;
        analysisServer.server.onError.listen((ServerError error) {
          _logger.severe('server error${error.isFatal ? ' (fatal)' : ''}',
              error.message, StackTrace.fromString(error.stackTrace));
        });
        await analysisServer.server.onConnected.first;
        await analysisServer.server.setSubscriptions(['STATUS']);

        VersionResult version = await analysisServer.server.getVersion();
        _logger.info('Analysis server started with version: ${version.version}');

        onResultsStreamSubscription = analysisServer.completion.onResults.listen(_onResultsListener);
        onStatusStreamSubscription = analysisServer.server.onStatus.listen(_onStatusListener);
        onErrorsStreamSubscription = analysisServer.analysis.onErrors.listen(_onErrorsListener);

        // Completer analysisComplete = getAnalysisCompleteCompleter();
        // await analysisServer.analysis
        //     .setAnalysisRoots([sourceDirectory.path], []);
        // await _sendAddOverlays({mainPath: _WARMUP_SRC});
        // await analysisComplete.future;
        // await _sendRemoveOverlays();
      });
    }

    return _init;
  }

  /// Cleanly shutdown the Analysis Server.
  Future shutdown() {
    return analysisServer.server
        .shutdown()
        .timeout(Duration(seconds: 1))
        .catchError((e) => null)
        .whenComplete(() {
          analysisServer.dispose();
          dispose();
        });
  }

  Future<int> get onExit {
    // Return when the analysis server exits. We introduce a delay so that when
    // we terminate the analysis server we can exit normally.
    return analysisServer.processCompleter.future.then((int code) {
      return Future.delayed(Duration(seconds: 1), () => code);
    });
  }

  void dispose() {
    onResultsStreamSubscription?.cancel();
    onStatusStreamSubscription?.cancel();
    onErrorsStreamSubscription?.cancel();
    _analysisResultsCompleters.clear();
    _analysisStatusCompleters.clear();
    _analysisErrors.clear();

    onResultsStreamSubscription = null;
    onStatusStreamSubscription = null;
    onErrorsStreamSubscription = null;
    _analysisResultsCompleters = null;
    _analysisStatusCompleters = null;
    _analysisErrors = null;
  }

  // -------- LISTENERS

  void _onRead(String str) {
    if (dumpServerMessages) _logger.info('<-- $str');
  }

  void _onWrite(String str) {
    if (dumpServerMessages) _logger.info('--> $str');
  }

  void _onResultsListener(CompletionResults result) {
    if (result.isLast) {
      Completer<CompletionResults> completer = _analysisResultsCompleters.remove(result.id);
      if (completer != null) {
        completer.complete(result);
      }
    }
  }

  void _onStatusListener(ServerStatus status) {
    if (status.analysis == null) return;

    if (!status.analysis.isAnalyzing) {
      for (Completer completer in _analysisStatusCompleters) {
        completer.complete();
      }

      _analysisStatusCompleters.clear();
    }
  }

  void _onErrorsListener(AnalysisErrors result) {
    if (result.errors.isEmpty) {
      _analysisErrors.remove(result.file);
    } else {
      _analysisErrors[result.file] = result.errors;
    }
  }

  // -------- GENERAL METHODS

  String _getPathFromName(String sourceName) {
    return path.join(sourceDirectory.path, sourceName);
  }

  Completer getAnalysisCompleteCompleter() {
    Completer completer = Completer();
    _analysisStatusCompleters.add(completer);
    return completer;
  }

  String get _sdkVersion {
    return File(path.join(_sdkPath, 'version')).readAsStringSync().trim();
  }

  // -------- API METHODS

  // Future<api.FormatResponse> format(String src, int offset) {
  //   return _formatImpl(src, offset).then((FormatResult editResult) {
  //     List<SourceEdit> edits = editResult.edits;

  //     edits.sort((e1, e2) => -1 * e1.offset.compareTo(e2.offset));

  //     for (SourceEdit edit in edits) {
  //       src = src.replaceRange(
  //           edit.offset, edit.offset + edit.length, edit.replacement);
  //     }

  //     return api.FormatResponse(src, editResult.selectionOffset);
  //   }).catchError((error) {
  //     _logger.fine("format error: $error");
  //     return api.FormatResponse(src, offset);
  //   });
  // }

  // Future<FormatResult> _formatImpl(String src, int offset) async {
  //   _logger.fine("FormatImpl: Scheduler queue: ${serverScheduler.queueCount}");

  //   return serverScheduler.schedule(ClosureTask(() async {
  //     await _loadSources({mainPath: src});
  //     FormatResult result =
  //         await analysisServer.edit.format(mainPath, offset, 0);
  //     await _unloadSources();
  //     return result;
  //   }, timeoutDuration: _ANALYSIS_SERVER_TIMEOUT));
  // }
  
}
