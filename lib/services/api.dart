import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/browser.dart'
    if (dart.library.io) 'package:ones_llm/crossPlatform/fakeDioBrowser.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:get/get.dart' hide Response;
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'package:ones_llm/services/api/error.dart';
import 'package:ones_llm/configs/variables.dart';

class Conversation {
  String name;
  String description;
  String id;

  Conversation(
      {required this.name, 
      required this.description, 
      required this.id});

}

class Message {
  int? id;
  String conversationId;
  String role;
  String text;
  String? modelName;
  bool error;
  bool sending;
  Message(
      {this.id,
      required this.conversationId,
      required this.text,
      required this.role,
      this.modelName,
      this.error = false,
      this.sending = false});
      
}

enum LoginResponse { success, badUserOrPassed, unknown }

enum RegisterResponse { success, existName, unknown }

class ApiService extends GetxService {
  late Dio _dio;
  final StreamTransformer<Uint8List, List<int>> unit8Transformer =
      StreamTransformer.fromHandlers(
    handleData: (data, sink) {
      sink.add(List<int>.from(data));
    },
  );

  @override
  void onInit() async {
    super.onInit();
    _dio = Dio();
    if (kIsWeb) {
      var adapter = BrowserHttpClientAdapter(withCredentials: true);
      _dio.httpClientAdapter = adapter;
    } else {
      _dio.interceptors.add(CookieManager(PersistCookieJar(storage: FileStorage("${appDocDir.path}/.cookie"))));
    }
    _dio.options.baseUrl = apiBaseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: 30000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    _dio.options.headers["Accept"] = "application/json";
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors.add(errorInterceptor);
  }

  Future<T> _get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      bool decodeAsJson=true}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters?.map((key, value) => MapEntry(
            key,
            base64Encode(
                utf8.encode(value is String ? value : jsonEncode(value))))),
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return decodeAsJson? jsonDecode(response.data!): response.data! as T;
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Response<T>> _post<T>(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters?.map(
            (key, value) => MapEntry(key, base64Encode(utf8.encode(value)))),
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<LoginResponse> login(username, password) async {
    final response = await _get<String>('/user/login',
        queryParameters: {'user': username, 'pd': password});
    switch (response) {
      case 'success':
        return LoginResponse.success;
      case 'invalid_username_or_password':
        return LoginResponse.badUserOrPassed;
      default:
        return LoginResponse.unknown;
    }
  }

  Future<LoginResponse> logout() async {
    final response = await _get<String>('/user/logout');
    switch (response) {
      case 'success':
        return LoginResponse.success;
      default:
        return LoginResponse.unknown;
    }
  }

  Future<RegisterResponse> register(username, password) async {
    final response = await _get<String>('/user/register',
        queryParameters: {'user': username, 'pd': password});
    switch (response) {
      case 'success':
        return RegisterResponse.success;
      case 'user_name_exist':
        return RegisterResponse.existName;
      default:
        return RegisterResponse.unknown;
    }
  }

  Future<Map<String, String>> getAllApiKey() async {
    final response = await _get<Map<String, dynamic>>(
      '/api/list',
    );
    return Map.from(response);
  }

  Future<bool> setApiKey(String provider, String key) async {
    final response = await _get<String>('/api/add', queryParameters: {
      'name': provider,
      'key': key,
    });
    return true;
  }

  Future<List<String>> getAllProviders() async {
    final response = await _get<List<dynamic>>(
      '/api/providers',
    );
    return response.cast();
  }

  Future<Map<String, List<String>>> getAvailableProviderModels() async {
    final response = await _get<Map<String, dynamic>>(
      '/api/models',
    );
    final Map<String, List<String>> res = {};
    for (var element in response.entries) {
      res[element.key] = (element.value as List<dynamic>)
          .map((item) => item as String)
          .toList();
    }
    return res;
  }

  Future<List<Conversation>> getConversations() async {
    final response = await _get<Map<String, dynamic>>(
      '/chat/list',
    );
    List<Conversation> convList = [];
    response.forEach((key, value) {
      convList.add(Conversation(
          name: value['chat_title'],
          description: value['chat_title'],
          id: key));
    });
    return convList;
  }

  Future<String> addConversation(name) async {
    final response = await _get<String>(
      '/chat/new',
      queryParameters: {'title': name}
    );
    return response;
  }

  Future<bool> renameConversation(conversationId, newName) async {
    final response = await _get<String>('/chat/title',
        queryParameters: {'cid': conversationId, 'title': newName});
    return true;
  }

  Future<bool> deleteConversation(conversationId) async {
    final response = await _get<String>('/chat/del',
        queryParameters: {'cid': conversationId});
    return true;
  }

  Future<Map<String, List<Message>>> getMessages(
    conversationId,
  ) async {
    final response = await _get<Map<String, dynamic>>('/chat/get',
        queryParameters: {'cid': conversationId});
    List<Message> messageList = [];
    response['msg_list'].forEach((element) {
      messageList.add(Message(
          conversationId: conversationId,
          text: element['msg'],
          role: element['name']));
    });
    List<Message> tempMessageList = [];
    if (response['recv_msg_tmp'] is Map) {
      response['recv_msg_tmp'].forEach((k, v) {
        tempMessageList.add(Message(
            conversationId: conversationId, text: v['msg'], role: v['name']));
      });
    }
    return {"msgList": messageList, "tmpList": tempMessageList};
  }

  Future<List<Message>> sendMessage(
    String conversationId,
    String text,
    Map<String, List<String>> providerModels,
  ) async {
    final response = await _get<Map<String, dynamic>>('/chat/gen',
        queryParameters: {
          'cid': conversationId,
          'p': text,
          'provider_models': providerModels
        });
    List<Message> messageList = [];
    response.forEach((key, value) {
      switch (value['code']) {
        case 1:
          messageList.add(Message(
              conversationId: conversationId,
              modelName: key,
              text: value['msg'],
              role: value['name']));
          break;
        case 0:
          messageList.add(Message(
              conversationId: conversationId,
              modelName: key,
              text: value['msg'],
              role: value['name'],
              error: true));
          break;
      }
    });
    return messageList;
  }

  Stream<List<Message>> sendMessageStream(
    String conversationId,
    String text,
    Map<String, List<String>> providerModels,
  ) async* {
    final models = providerModels.values.expand((element) => element);    
    Map<String, Message> messageMap = {
      for (String model in models)
      model: Message(conversationId: conversationId, text: '', role: model, sending: true)
    };
    yield messageMap.values.toList();

    final response = await _get<ResponseBody>(
      '/chat/gen/stream',
      queryParameters: {
        'cid': conversationId,
        'p': text,
        'provider_models': providerModels
      },
      options: Options(responseType: ResponseType.stream),
      decodeAsJson: false
    );
    final Stream responseStream = response.stream
      .transform(unit8Transformer)
      .transform(const Utf8Decoder());
    print(response);

    await for (final chunk in responseStream) {
      print('object');
      print(chunk);
      for (final line in chunk.split('\n')) {
        if (line.isEmpty) continue;
        final msg = jsonDecode(line);
        messageMap[msg['model']]!.text+=msg['message'];
      }
      yield messageMap.values.toList();
    }
    messageMap.forEach((key, value) {value.sending = false;});
    yield messageMap.values.toList();
  }

  Future<bool> selectMessages(
    String conversationId,
    String model,
  ) async {
    final response = await _get<String>('/chat/sel',
        queryParameters: {'cid': conversationId, 'name': model});
    return true;
  }
}
