import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ones_llm/components/chat.dart';
import 'package:ones_llm/components/conversation.dart';

class MyHomePage extends GetResponsiveView {
  MyHomePage({super.key});

  @override
  Widget? phone() {
    print('phone');
    return Scaffold(
      appBar: AppBar(
        title: Text('appTitle'.tr),
      ),
      drawer: const ConversationWindow(),
      body: ChatWindow(),
    );
  }

  @override
  Widget? desktop() {
    print('desktop');
    return Scaffold(
      body: Card(
        margin: EdgeInsets.all(10),
        elevation: 5,
        child: Row(
        children: [
          ConversationWindow(),
          Expanded(child: ChatWindow()),
        ],
      ),
      )
    );
  }
}