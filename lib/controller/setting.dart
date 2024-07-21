import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:ones_llm/controller/conversation.dart';
import 'package:ones_llm/controller/message.dart';
import 'package:ones_llm/controller/model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ones_llm/services/api.dart';
import 'package:ones_llm/services/local.dart';

class SettingController extends GetxController {
  final keyControllers = {
    for (final element in Get.find<ModelController>().modelProviderMap.keys)
      element: TextEditingController()
  };
  
  final themeMode = ThemeMode.system.obs;
  var localeText = 'zh';

  final useStream = true.obs;
  final useWebSearch = false.obs;

  final version = "1.0.0".obs;

  var isLogin = false;

  final ApiService api = Get.find();
  final LocalService local = Get.find();

  static SettingController get to => Get.find();

  @override
  void onInit() async {
    // await getThemeModeFromPreferences();
    fillApiKeyToControllers(keyControllers);
    isLogin = local.isLogin;
    localeText = local.local.toString();
    themeMode.value = local.theme;
    await initAppVersion();
    super.onInit();
    update();
  }

  initAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
  }

  void setThemeMode(ThemeMode model) async {
    Get.changeThemeMode(model);
    themeMode.value = model;
    local.theme = model;
    update();
  }

  void setLocale(Locale lol) {
    local.local = lol;
    localeText = lol.languageCode;
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
    for (final ctrl in controllerMap.entries) {
      api.setApiKey(ctrl.key, ctrl.value.text);
    }
  }

  void logout() async {
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
