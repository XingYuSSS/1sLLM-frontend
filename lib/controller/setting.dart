import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:ones_llm/controller/conversation.dart';
import 'package:ones_llm/controller/message.dart';
import 'package:ones_llm/controller/model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ones_llm/services/api.dart';
import 'package:ones_llm/services/local.dart';
import 'package:ones_llm/configs/variables.dart';

class SettingController extends GetxController {
  late Map<String, TextEditingController> keyControllers = {};

  var themeMode = ThemeMode.system;
  var localeText = 'zh';

  var useStream = false;
  var useWebSearch = false;

  var version = "1.0.0";

  var isLogin = false;

  final ApiService api = Get.find();
  final LocalService local = Get.find();

  @override
  void onInit() async {
    if (!singleModelMode) {
      keyControllers = {
        for (final element in Get.find<ModelController>().modelProviderMap.keys)
          element: TextEditingController()
      };
      fillApiKeyToControllers(keyControllers);
    }

    isLogin = local.isLogin;
    localeText = local.local.toString();
    themeMode = local.theme;
    useStream = local.useStream;
    await initAppVersion();
    super.onInit();
    update();
  }

  initAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  void setThemeMode(ThemeMode model) async {
    Get.changeThemeMode(model);
    themeMode = model;
    local.theme = model;
    update();
  }

  void setLocale(Locale lol) {
    Get.updateLocale(lol);
    local.local = lol;
    localeText = lol.languageCode;
    update();
  }

  void setUseStream(bool use) {
    local.useStream = use;
    useStream = use;
    update();
  }

  fillApiKeyToControllers(
      Map<String, TextEditingController> controllerMap) async {
    final keys = await api.getAllApiKey();
    for (final ctrl in controllerMap.entries) {
      ctrl.value.text = keys[ctrl.key] ?? '';
    }
  }

  setApiKeyFromControllers(
      Map<String, TextEditingController> controllerMap) async {
    EasyLoading.show(
        status: 'updating'.tr,
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black);
    final callList = [
      for (final ctrl in controllerMap.entries)
        api.setApiKey(ctrl.key, ctrl.value.text),
    ];
    await Future.wait(callList);
    EasyLoading.dismiss();
  }

  void logout() async {
    EasyLoading.show(status: 'logingOut'.tr);
    final res = await api.logout();
    switch (res) {
      case LoginResponse.success:
        EasyLoading.dismiss();
        EasyLoading.showSuccess('logoutSuccess'.tr);
        local.userName = '';
        isLogin = false;
        Get.find<ConversationController>()
          ..conversationList.clear()
          ..currentConversationId.value = '';
        Get.find<MessageController>()
          ..messageList.clear()
          ..selectingMessageList.clear()
          ..selecting.value = false;
        Get.back();
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
}
