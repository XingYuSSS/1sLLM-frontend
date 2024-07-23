import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:ones_llm/configs/variables.dart';

Future initAll() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  initEasyLoading();
  await initVar();
}

void initEasyLoading() {
  EasyLoading.instance
    ..backgroundColor = Get.theme.colorScheme.primaryContainer
    ..textColor = Get.theme.colorScheme.onPrimaryContainer;
}
