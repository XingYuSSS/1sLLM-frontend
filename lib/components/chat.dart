import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:ones_llm/components/chat/model_panel.dart';
import 'package:ones_llm/components/chat/select_card.dart';
import 'package:ones_llm/components/chat/welcome.dart';
import 'package:ones_llm/controller/model.dart';
import 'package:ones_llm/components/chat/message_card.dart';
import 'package:ones_llm/controller/conversation.dart';
import 'package:ones_llm/controller/message.dart';
import 'package:ones_llm/configs/variables.dart';

class ChatWindow extends StatelessWidget {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  ChatWindow({super.key});

  @override
  Widget build(BuildContext context) {
    var width2 = MediaQuery.of(context).size.width;
    double lrpadding = width2 > 1282 ? (width2 - 1250) / 2 : 16;
    return Container(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      padding: EdgeInsets.fromLTRB(lrpadding, 16, lrpadding, 16),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
          color: Get.theme.colorScheme.background.darken(2)),
      child: Column(
        children: [
          Expanded(
            child: GetX<MessageController>(
              builder: (controller) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToNewMessage();
                });
                if (controller.messageList.isNotEmpty) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: controller.messageList.length +
                        (controller.selectingMessageList.isNotEmpty ? 1 : 0),
                    itemBuilder: (context, index) {
                      final msgLen = controller.messageList.length;
                      if (index < msgLen) {
                        return MessageCard(
                          message: controller.messageList[index],
                        );
                      } else {
                        return SelectCard(
                          selectList: controller.selectingMessageList,
                          onSelect: controller.selectMessage,
                          displayNum: 2,
                        );
                      }
                    },
                  );
                } else {
                  return Welcome(
                    promptList: const [
                      '去哈尔滨要准备什么东西？',
                      '帮我用python实现二分查找',
                      '我要过生日了，你可以祝我生日快乐吗？'
                    ],
                    sendPrompt: _sendPrompt,
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (!singleModelMode) ...[
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Obx(
                    () => Tooltip(
                      message: 'selectModel'.tr,
                      child: ElevatedButton(
                        onPressed: Get.find<MessageController>()
                                .selecting
                                .isTrue
                            ? null
                            : () {
                                Get.find<ModelController>()
                                    .getAvailableProviderModels();
                                Get.dialog(
                                    const Dialog(child: ModelSelectWindow()));
                              },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(FontAwesomeIcons.bars),
                      ),
                    ),
                  ),
                ),
              ],
              Expanded(
                child: Obx(
                  () => TextFormField(
                    enabled: Get.find<MessageController>().selecting.isFalse,
                    style: const TextStyle(fontSize: 16),
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: "inputPrompt".tr,
                      hintText: "inputPromptTips".tr,
                      isCollapsed: true,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    maxLines: 5,
                    minLines: 1,
                    // maxLines: null,
                    focusNode: FocusNode(
                      onKeyEvent: _handleKeyEvent,
                    ),
                  ),
                ),
              ),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Obx(
                  () => Tooltip(
                    message: 'send'.tr,
                    child: ElevatedButton(
                      onPressed: Get.find<MessageController>().selecting.isTrue
                          ? null
                          : () {
                              _sendMessage();
                            },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(Icons.send),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final message = _textController.text.trim();
    final MessageController messageController = Get.find();
    final ConversationController conversationController = Get.find();
    final ModelController modelController = Get.find();
    if (message.isNotEmpty) {
      var conversationId = conversationController.currentConversationId.value;
      if (conversationId.isEmpty) {
        conversationId = await conversationController.addConversation(
          message.substring(0, message.length > 20 ? 20 : message.length),
          message,
        );
        conversationController.setCurrentConversationId(conversationId);
      }
      bool ret = await messageController.sendMessage(
          conversationId, message, modelController.getSelectedMap());
      if (ret) {
        _textController.text = '';
      }
    }
  }

  void _sendPrompt(prompt) async {
    final MessageController messageController = Get.find();
    final ConversationController conversationController = Get.find();
    final ModelController modelController = Get.find();
    final conversationId = await conversationController.addConversation(
      prompt.substring(0, prompt.length > 20 ? 20 : prompt.length),
      prompt,
    );
    conversationController.setCurrentConversationId(conversationId);
    bool ret = await messageController.sendMessage(
        conversationId, prompt, modelController.getSelectedMap());
    if (ret) {
      _textController.text = '';
    }
  }

  KeyEventResult _handleKeyEvent(node, event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter &&
        !HardwareKeyboard.instance.physicalKeysPressed.any((key) => {
              PhysicalKeyboardKey.shiftLeft,
              PhysicalKeyboardKey.shiftRight,
            }.contains(key))) {
      _sendMessage();
      return KeyEventResult.handled;
    } else if (event is KeyRepeatEvent) {
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }

  void _scrollToNewMessage() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
