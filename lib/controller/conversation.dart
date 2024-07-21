import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ones_llm/controller/message.dart';

import 'package:ones_llm/services/api.dart';
import 'package:ones_llm/services/local.dart';

class ConversationController extends GetxController {
  final conversationList = <Conversation>[].obs;
  final currentConversationId = "".obs;

  final ApiService api = Get.find();
  final LocalService local = Get.find();

  static ConversationController get to => Get.find();
  @override
  void onInit() async {
    conversationList.value = await api.getConversations();
    super.onInit();
  }

  void getConversations() async {
    conversationList.value = await api.getConversations();
  }

  void setCurrentConversationId(String id) {
    currentConversationId.value = id;
    update();
  }

  void deleteConversation(int index) async {
    Conversation conversation = conversationList[index];
    await api.deleteConversation(conversation.id);
    conversationList.value = await api.getConversations();
    update();
  }

  void renameConversation(String id, String newName) async {
    await api.renameConversation(id, newName);
    conversationList.value = await api.getConversations();
    update();
  }

  Future<String> addConversation(String name, String description) async {
    final id = await api.addConversation(name);
    conversationList.add(Conversation(
      name: name, 
      description: description, 
      id: id)
    );
    currentConversationId.value = id;
    update();
    conversationList.value = await api.getConversations();
    update();
    return id;
  }

  void clearConversations() async {
    conversationList.clear();
    currentConversationId.value = '';
  }

  void logout() async {
    final res = await api.logout();
    switch (res) {
      case LoginResponse.success:
        EasyLoading.dismiss();
        EasyLoading.showSuccess('logoutSuccess'.tr);
        local.userName = '';
        // isLogin = false;
        clearConversations();
        Get.find<MessageController>().clearMessages();
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
