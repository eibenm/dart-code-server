library services.sdk_manager;

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;

/// Generally, this should be a singleton instance (it's a heavy-weight object).
class SdkManager {
  static Sdk _sdk;
  static Sdk get sdk => _sdk ?? (_sdk = HostSdk());
}

abstract class Sdk {
  Future init();

  /// Report the current version of the SDK.
  String get version {
    String ver = versionFull;
    if (ver.contains('-')) ver = ver.substring(0, ver.indexOf('-'));
    return ver;
  }

  /// Report the current version of the SDK, including any `-dev` suffix.
  String get versionFull;

  /// Get the path to the sdk.
  String get sdkPath;
}

class HostSdk extends Sdk {
  Future init() => Future.value();

  String get versionFull => Platform.version;

  String get sdkPath => path.dirname(path.dirname(Platform.resolvedExecutable));
}
