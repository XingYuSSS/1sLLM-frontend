import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ones_llm/components/login.dart';
import 'package:ones_llm/services/local.dart';

final errorInterceptor = InterceptorsWrapper(
  onError: (error, handler) async {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        // 连接超时处理
        EasyLoading.showError("connectionTimeout".tr);
        break;
      case DioExceptionType.sendTimeout:
        // 发送超时处理
        EasyLoading.showError("sendTimeout".tr);
        break;
      case DioExceptionType.receiveTimeout:
        // 接收超时处理
        EasyLoading.showError("receiveTimeout".tr);
        break;
      case DioExceptionType.badResponse:
        // 服务器响应错误处理
        switch (error.response!.statusCode) {
          case 403:
            Get.dialog(const LoginDialog());
            Get.find<LocalService>().userName = '';
            break;
          case 401:
            handler.resolve(error.response!);break;
          default:
            EasyLoading.showError("error: $error");
        }
        break;
      case DioExceptionType.cancel:
        // 请求取消处理
        EasyLoading.showError("requestCanceled".tr);
        break;
      case DioExceptionType.connectionError:
        // 连接错误处理
        EasyLoading.showError("connectionError".tr);
        break;
      case DioExceptionType.unknown:
      default:
        EasyLoading.showError("${"unknownError".tr}: $error");
        // 其他错误处理
        break;
    }
  },
);
