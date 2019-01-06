library services.shelf_cors;

import 'package:shelf/shelf.dart';

/// Middleware which allows all requests outside our domain.
///
/// Uses [CORS headers](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS)
Middleware corsHeadersMiddleware({Map<String, String> corsHeaders}) {
  if (corsHeaders == null) {
    // By default allow access from everywhere.
    corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Max-Age': '86400',
      'Access-Control-Allow-Headers':
          'Origin, X-Requested-With, Content-Type, Accept',
    };
  }

  // Handle preflight (OPTIONS) requests by just adding headers and an empty response.
  Response _handleOptionsRequest(Request request) {
    if (request.method == 'OPTIONS') {
      return Response.ok(null, headers: corsHeaders);
    } else {
      return null;
    }
  }

  Response _addCorsHeaders(Response response) {
    return response.change(headers: corsHeaders);
  }

  return createMiddleware(
      requestHandler: _handleOptionsRequest, responseHandler: _addCorsHeaders);
}
