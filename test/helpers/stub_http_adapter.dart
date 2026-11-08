import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef StubHandler = Future<ResponseBody> Function(RequestOptions options);

/// Test-only [HttpClientAdapter] that never touches the network.
class StubHttpAdapter implements HttpClientAdapter {
  StubHttpAdapter(this._handler);

  final StubHandler _handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonResponse(Object? body, {int statusCode = 200}) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );
}
