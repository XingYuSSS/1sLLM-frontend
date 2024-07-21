import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ones_llm/components/login.dart';

class LoginPage extends GetResponsiveView {
  LoginPage({super.key});

  @override
  Widget? phone() {
    print('phone');
    return Scaffold(
      appBar: AppBar(
        title: Text('login'.tr),
      ),
      body: const LoginWindow(),
    );
  }

  @override
  Widget? desktop() {
    print('desktop');
    return Scaffold(
      appBar: AppBar(
        title: Text('login'.tr),
      ),
      body: const LoginWindow(),
    );
  }
}