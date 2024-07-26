import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:ones_llm/configs/init.dart';
import 'package:ones_llm/configs/route.dart';
import 'package:ones_llm/configs/translations.dart';
import 'package:ones_llm/controller/conversation.dart';
import 'package:ones_llm/controller/message.dart';
import 'package:ones_llm/controller/model.dart';
import 'package:ones_llm/pages/home.dart';
import 'package:ones_llm/services/api.dart';
import 'package:ones_llm/services/local.dart';

void main() async {
  await initAll();
  Get.put(ApiService());
  Get.put(LocalService());
  Get.put(ModelController());
  Get.put(ConversationController());
  Get.put(MessageController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalService local = Get.find();
    return GetMaterialApp(
      initialRoute: '/',
      getPages: routes,
      unknownRoute:
          GetPage(name: '/', page: () => MyHomePage()),
      theme: FlexThemeData.light(scheme: FlexScheme.brandBlue),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.brandBlue),
      themeMode: local.theme,
      locale: local.local,
      fallbackLocale: const Locale('en', 'US'),
      translations: OnesLLMTranslations(),
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
    );
  }
}
