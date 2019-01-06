library services.endpoints_server;

import 'dart:async';
import 'dart:io';

import 'package:rpc/rpc.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'api_server.dart';
import 'shelf_cors.dart';

const _API_PREFIX = '/api';

class EndpointsServer {
  static Future<EndpointsServer> serve(String sdkPath, int port) {
    EndpointsServer endpointsServer = EndpointsServer._(sdkPath, port);
    return shelf_io
        .serve(endpointsServer.handler, InternetAddress.anyIPv4, port)
        .then((HttpServer server) {
      endpointsServer.server = server;
      return endpointsServer;
    });
  }

  final int port;
  HttpServer server;
  ApiServer apiServer;
  DartServicesAPIServer dartServicesAPIServer;

  shelf.Pipeline pipeline;
  shelf.Handler handler;

  EndpointsServer._(String sdkPath, this.port) {
    dartServicesAPIServer = DartServicesAPIServer(sdkPath);
    dartServicesAPIServer.init();
    apiServer = ApiServer(apiPrefix: _API_PREFIX, prettyPrint: true)
      ..addApi(dartServicesAPIServer);

    pipeline = shelf.Pipeline()
        .addMiddleware(shelf.logRequests())
        .addMiddleware(corsHeadersMiddleware());

    handler = pipeline.addHandler(_apiHandler);
  }

  Future<shelf.Response> _apiHandler(shelf.Request request) {
    HttpApiRequest apiRequest = HttpApiRequest(
        request.method, request.requestedUri, request.headers, request.read());

    // Promote text/plain requests to application/json.
    if (apiRequest.headers['content-type'] == 'text/plain; charset=utf-8') {
      apiRequest.headers['content-type'] = 'application/json; charset=utf-8';
    }

    return apiServer
        .handleHttpApiRequest(apiRequest)
        .then((HttpApiResponse apiResponse) {
      return shelf.Response(apiResponse.status,
          body: apiResponse.body,
          headers: Map<String, String>.from(apiResponse.headers));
    });
  }
}
