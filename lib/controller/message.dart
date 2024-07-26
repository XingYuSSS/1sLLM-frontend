import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:ones_llm/services/api.dart';
import 'package:ones_llm/services/local.dart';


class MessageController extends GetxController { 
  final messageList = <Message>[].obs;
  final selectingMessageList = <Message>[].obs;
  final sending = false.obs;
  final selecting = false.obs;
  final displayNum = 1.obs;

  final ApiService api = Get.find();
  final LocalService local = Get.find();

  void loadAllMessages(String conversationId) async {
    if (conversationId == '')return;
    final msg = await api.getMessages(conversationId);
    messageList.value = msg['msgList']!;
    selectingMessageList.value = msg['tmpList']!;
    selecting.value = selectingMessageList.isNotEmpty? true : false;
  }

  void clearMessages() async {
    messageList.value = [];
    selectingMessageList.value = [];
    selecting.value = false;
  }

  Future<bool> sendMessage(
    String conversationId,
    String text,
    Map<String, List<String>> selectProviderModels
  ) async {
    if (selectProviderModels.isEmpty){
      EasyLoading.showError('notSelectModel'.tr);
      return false;
    }
    selecting.value = true;
    sending.value = true;
    final messages = await api.getMessages(conversationId);
    final sendedMessage = Message(conversationId: conversationId, text: text, role: local.userName);
    messageList.value = [...messages['msgList']!, sendedMessage];

    if(local.useStream) {
      final stream = api.sendMessageStream(conversationId, text, selectProviderModels).asBroadcastStream();

      final first = await stream.first;
      if(first.length == 1){
        messageList.add(first[0]);
        selecting.value = false;
      } else {
        selectingMessageList.value = first;
      }

      await for (final newMessages in stream) {
        final msg = newMessages.map((e) {e.text+='_'; return e;}).toList();
        msg.length == 1
          ? messageList.last = msg[0]
          : selectingMessageList.value = msg;
      }
    } else {
      EasyLoading.show(status: 'generatingResponse'.tr, dismissOnTap: true);
      final newMessages = await api.sendMessage(conversationId, text, selectProviderModels);
      EasyLoading.dismiss();
      if(newMessages.length == 1) {
        messageList.add(newMessages[0]);
        selecting.value = false;
      } else {
        selectingMessageList.value = newMessages;
      }
    }
    sending.value = false;
    return true;
  }

  void selectMessage(
    Message message
  ) async {
    await api.selectMessages(message.conversationId, message.role);
    selectingMessageList.value = [];
    loadAllMessages(message.conversationId);
  }

}
