import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:ones_llm/controller/conversation.dart';
import 'package:ones_llm/services/api.dart';
import 'package:ones_llm/services/local.dart';

enum LoginStatu { login, register }

class LoginController extends GetxController {
  // var failmessage = '';
  // var userName = '';
  var statu = LoginStatu.login;
  final userController = TextEditingController();
  final pdController = TextEditingController();
  final pd2Controller = TextEditingController();
  // final _userController = Get.find<UserController>();
  final ApiService api = Get.find();
  final LocalService local = Get.find();

  void register() async {
    final username = userController.text.trim();
    final password = pdController.text.trim();
    EasyLoading.show(status: 'signingUp'.tr);

    if (pd2Controller.text.trim() != password) {
      // failmessage = "notSame";
      EasyLoading.dismiss();
      EasyLoading.showError('notSame'.tr);
      return;
    }

    final res = await api.register(username, password);
    switch (res) {
      case RegisterResponse.success:
        EasyLoading.dismiss();
        EasyLoading.showSuccess('registerSuccess'.tr);
        toLogin();
        break;
      case RegisterResponse.existName:
        // failmessage = 'badUser'.tr;
        EasyLoading.showError('existName'.tr);
        break;
      case RegisterResponse.unknown:
        // failmessage = 'unknownError'.tr;
        EasyLoading.showError('unknownError'.tr);
        break;
    }

  }

  void login() async {
    final username = userController.text.trim();
    final password = pdController.text.trim();
    // statu = LoginStatu.tryingLogin;
    EasyLoading.show(status: 'loginingIn'.tr);

    final res = await api.login(username, password);
    switch (res) {
      case LoginResponse.success:
        EasyLoading.dismiss();
        EasyLoading.showSuccess('loginSuccess'.tr);

        // statu = LoginStatu.hasLogin;
        local.userName = username;
        Get.find<ConversationController>().getConversations();
        Get.offAllNamed('/');
        break;
      case LoginResponse.badUserOrPassed:
        // statu = LoginStatu.failLogin;
        // failmessage = 'badUser'.tr;
        EasyLoading.showError('badUserOrPassed'.tr);
        break;
      case LoginResponse.unknown:
        // statu = LoginStatu.failLogin;
        // failmessage = 'unknownError'.tr;
        EasyLoading.showError('unknownError'.tr);
        break;
    }
  }

  void toRegister() {
    statu = LoginStatu.register;
    userController.text = '';
    pdController.text = '';
    pd2Controller.text = '';
    update();
  }

  void toLogin() {
    statu = LoginStatu.login;
    userController.text = '';
    pdController.text = '';
    pd2Controller.text = '';
    update();
  }
}
