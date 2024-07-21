import 'dart:typed_data';

import 'package:dio/dio.dart';

class BrowserHttpClientAdapter implements HttpClientAdapter{
  BrowserHttpClientAdapter({withCredentials}){}

  @override
  void close({bool force = false}) {
    // TODO: implement close
  }

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) {
    // TODO: implement fetch
    throw UnimplementedError();
  }
}