import 'package:http/http.dart';

class FetchClient extends BaseClient {
  /// Create new HTTP client based on Fetch API.
  FetchClient({
    mode,
    credentials,
    cache,
    referrer,
    referrerPolicy,
    redirectPolicy,
    streamRequests,
  });
  
  @override
  Future<FetchResponse> send(BaseRequest request) async {
    // TODO: implement send
    throw UnimplementedError();
  }
}

enum RequestMode {
  sameOrigin,
  noCors,
  cors,
  navigate,
  webSocket;
}

class FetchResponse extends StreamedResponse implements BaseResponseWithUrl {
  FetchResponse(super.stream, super.statusCode, {
    cancel,
    required this.url,
    redirected,
    super.contentLength,
    super.request,
    super.headers,
    super.isRedirect,
    super.persistentConnection,
    super.reasonPhrase,
  });
  @override
  final Uri url;
}

enum RequestCredentials {
  sameOrigin,
  omit,
  cors,
}

