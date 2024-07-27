import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ones_llm/services/api.dart';
import 'package:ones_llm/components/chat/markdown.dart';
import 'package:ones_llm/services/local.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final userName = Get.find<LocalService>().userName;
    if (message.role == userName) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(message.role,
                            style: Get.textTheme.bodyLarge
                                ?.apply(color: Get.theme.colorScheme.onBackground.brighten(2))),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      alignment: Alignment.centerRight,
                      child: Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 16,
                        ),
                        message.text,
                      ),
                    ),
                  ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Image.asset('images/avatar_user.png',
                    width: 35, height: 35),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Image.asset('images/avator_assistant.png',
                    width: 35, height: 35),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text(message.role,
                            style: Get.textTheme.bodyLarge
                                ?.apply(color: Get.theme.colorScheme.onBackground.brighten(2))),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      child: Card(
                        color: Get.theme.colorScheme.background.darken(5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Markdown(text: message.text+(message.sending?'_':'')),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
