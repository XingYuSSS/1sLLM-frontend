import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:ones_llm/configs/variables.dart';

Future initAll() async {
  initEasyLoading();
  await initVar();
}

void initEasyLoading() {
  EasyLoading.instance
    ..backgroundColor = Get.theme.colorScheme.primaryContainer
    ..textColor = Get.theme.colorScheme.onPrimaryContainer;
}
