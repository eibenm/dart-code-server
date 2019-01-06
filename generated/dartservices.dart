// This is a generated file (see the discoveryapis_generator project).

// ignore_for_file: unnecessary_cast

library server_app.dartservices.v1;

import 'dart:core' as core;
import 'dart:async' as async;

import 'package:_discoveryapis_commons/_discoveryapis_commons.dart' as commons;
import 'package:http/http.dart' as http;

export 'package:_discoveryapis_commons/_discoveryapis_commons.dart'
    show ApiRequestError, DetailedApiRequestError;

const core.String USER_AGENT = 'dart-api-client dartservices/v1';

/// Dart services server API
class DartservicesApi {
  final commons.ApiRequester _requester;

  DartservicesApi(http.Client client,
      {core.String rootUrl: "http://localhost:8080/",
      core.String servicePath: "dartservices/v1/"})
      : _requester =
            new commons.ApiRequester(client, rootUrl, servicePath, USER_AGENT);

  /// Request parameters:
  ///
  /// Completes with a [MyResponse].
  ///
  /// Completes with a [commons.ApiRequestError] if the API endpoint returned an
  /// error.
  ///
  /// If the used [http.Client] completes with an error when making a REST call,
  /// this method will complete with the same error.
  async.Future<MyResponse> myFutureMethod() {
    var _url = null;
    var _queryParams = new core.Map<core.String, core.List<core.String>>();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    _url = 'futureMethod';

    var _response = _requester.request(_url, "GET",
        body: _body,
        queryParams: _queryParams,
        uploadOptions: _uploadOptions,
        uploadMedia: _uploadMedia,
        downloadOptions: _downloadOptions);
    return _response.then((data) => new MyResponse.fromJson(data));
  }

  /// Request parameters:
  ///
  /// Completes with a [MyResponse].
  ///
  /// Completes with a [commons.ApiRequestError] if the API endpoint returned an
  /// error.
  ///
  /// If the used [http.Client] completes with an error when making a REST call,
  /// this method will complete with the same error.
  async.Future<MyResponse> myMethod() {
    var _url = null;
    var _queryParams = new core.Map<core.String, core.List<core.String>>();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    _url = 'someMethod';

    var _response = _requester.request(_url, "GET",
        body: _body,
        queryParams: _queryParams,
        uploadOptions: _uploadOptions,
        uploadMedia: _uploadMedia,
        downloadOptions: _downloadOptions);
    return _response.then((data) => new MyResponse.fromJson(data));
  }

  /// Return the current SDK version for DartServices.
  ///
  /// Request parameters:
  ///
  /// Completes with a [VersionResponse].
  ///
  /// Completes with a [commons.ApiRequestError] if the API endpoint returned an
  /// error.
  ///
  /// If the used [http.Client] completes with an error when making a REST call,
  /// this method will complete with the same error.
  async.Future<VersionResponse> version() {
    var _url = null;
    var _queryParams = new core.Map<core.String, core.List<core.String>>();
    var _uploadMedia = null;
    var _uploadOptions = null;
    var _downloadOptions = commons.DownloadOptions.Metadata;
    var _body = null;

    _url = 'version';

    var _response = _requester.request(_url, "GET",
        body: _body,
        queryParams: _queryParams,
        uploadOptions: _uploadOptions,
        uploadMedia: _uploadMedia,
        downloadOptions: _downloadOptions);
    return _response.then((data) => new VersionResponse.fromJson(data));
  }
}

class MyResponse {
  core.String result;

  MyResponse();

  MyResponse.fromJson(core.Map _json) {
    if (_json.containsKey("result")) {
      result = _json["result"];
    }
  }

  core.Map<core.String, core.Object> toJson() {
    final core.Map<core.String, core.Object> _json =
        new core.Map<core.String, core.Object>();
    if (result != null) {
      _json["result"] = result;
    }
    return _json;
  }
}

class VersionResponse {
  /// The Dart SDK version that DartServices is compatible with. This will be a
  /// semver string.
  core.String sdkVersion;

  /// The full Dart SDK version that DartServices is compatible with.
  core.String sdkVersionFull;

  VersionResponse();

  VersionResponse.fromJson(core.Map _json) {
    if (_json.containsKey("sdkVersion")) {
      sdkVersion = _json["sdkVersion"];
    }
    if (_json.containsKey("sdkVersionFull")) {
      sdkVersionFull = _json["sdkVersionFull"];
    }
  }

  core.Map<core.String, core.Object> toJson() {
    final core.Map<core.String, core.Object> _json =
        new core.Map<core.String, core.Object>();
    if (sdkVersion != null) {
      _json["sdkVersion"] = sdkVersion;
    }
    if (sdkVersionFull != null) {
      _json["sdkVersionFull"] = sdkVersionFull;
    }
    return _json;
  }
}
