import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ones_llm/components/login.dart';
import 'package:ones_llm/controller/conversation.dart';
import 'package:ones_llm/controller/message.dart';

class ConversationWindow extends StatelessWidget {
  const ConversationWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Get.theme.colorScheme.background,
          ),
      constraints: const BoxConstraints(maxWidth: 250,),
      child: GetX<ConversationController>(builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              // color: Theme.of(context).colorScheme.background.withAlpha(235),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                tileColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                // selectedColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(20),
                onTap: _newConversation,
                leading: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                title: Text(
                  'newConversation'.tr,
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),
            const Divider(thickness: .5),
            controller.conversationList.isEmpty
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'noConversationTips'.tr,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: controller.conversationList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          // color: Theme.of(context).colorScheme.background.withAlpha(235),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          child: Obx(() => ListTile(
                            tileColor: Theme.of(context).colorScheme.background,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            // selectedColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(20),
                            selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(200),
                            onTap: Get.find<MessageController>().sending.isTrue
                                  ? null
                                  : () {
                              _changeConversation(index);
                            },
                            selected:
                                controller.currentConversationId.value ==
                                    controller.conversationList[index].id,
                            title: Text(
                              controller.conversationList[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Get.textTheme.titleSmall,
                            ),
                            trailing: Builder(builder: (context) {
                              return IconButton(
                                  onPressed: Get.find<MessageController>().sending.isTrue
                                  ? null
                                  : () {
                                    _showConversationMenu(context, index);
                                  },
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color:
                                        Theme.of(context).colorScheme.onPrimaryContainer,
                                  ));
                            }),
                          ),),
                        );
                      },
                    ),
                  ),
            const Divider(thickness: .5),
            Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 10),
              child: ListTile(
                leading: Image.asset('images/avatar_user.png', width: 40, height: 40,),
                title: Text(controller.local.isLogin? controller.local.userName: '未登录'),
                subtitle: Text('个人签名', style: Get.textTheme.bodySmall,),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.local.isLogin? controller.logout(): Get.dialog(const LoginDialog());
                      }, 
                      tooltip: controller.local.isLogin? 'logout'.tr: 'login'.tr,
                      icon: controller.local.isLogin? const Icon(Icons.logout_outlined): const Icon(Icons.login_outlined),
                      iconSize: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        _closeDrawer();
                        Get.toNamed('/setting');
                      }, 
                      tooltip: 'settings'.tr,
                      icon: const Icon(Icons.settings_outlined),
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showConversationMenu(BuildContext context, int index) {
    final ConversationController controller = Get.find();
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        PopupMenuItem(
          value: "rename",
          child: Text('reName'.tr),
        ),
        PopupMenuItem(
          value: "delete",
          textStyle: Get.textTheme.bodyLarge?.apply(color: Colors.red),
          child: Text('delete'.tr),
        ),
      ],
    ).then((value) {
      if (value == "delete") {
        controller.deleteConversation(index);
        Get.find<MessageController>().clearMessages();
      } else if (value == "rename") {
        _renameConversation(context, index);
      }
    });
  }

  void _newConversation() {
    ConversationController controller = Get.find();
    controller.setCurrentConversationId("");
    MessageController messageController = Get.find();
    messageController.clearMessages();
  }

  void _renameConversation(BuildContext context, int index) {
    final ConversationController conversationController = Get.find();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
        controller.text = conversationController.conversationList[index].name;
        return AlertDialog(
          title: Text("renameConversation".tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'enterNewName'.tr,
                  hintText: 'enterNewName'.tr,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
                autovalidateMode: AutovalidateMode.always,
                maxLines: null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("cancel".tr),
            ),
            TextButton(
              onPressed: () {
                conversationController.renameConversation(
                  conversationController.conversationList[index].id,
                  controller.text
                );
                Navigator.of(context).pop();
              },
              child: Text("ok".tr),
            ),
          ],
        );
      },
    );
  }

  _changeConversation(int index) {
    ConversationController controller = Get.find();
    _closeDrawer();
    String conversationId = controller.conversationList[index].id;
    controller.setCurrentConversationId(conversationId);
    MessageController controllerMessage = Get.find();
    controllerMessage.loadAllMessages(conversationId);
  }

  void _closeDrawer() {
    if (GetPlatform.isMobile) {
      Get.back();
    }
  }
}
