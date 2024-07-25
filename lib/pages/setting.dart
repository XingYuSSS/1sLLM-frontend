import 'package:flutter/material.dart';
import 'package:ones_llm/components/common/text_form.dart';
import 'package:ones_llm/controller/setting.dart';
import 'package:get/get.dart';

class SettingPage extends GetResponsiveView {
  SettingPage({super.key});
  // final modelController = Get.find<ModelController>();
  // final controller = Get.find<SettingController>();

  @override
  Widget? builder() {
    var width2 = Get.size.width;
    double lrpadding = width2 > 682 ? (width2 - 650) / 2 : 16;
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed('/'),
        ),
      ),
      body: GetBuilder<SettingController>(
          init: SettingController(),
          builder: (controller) {
            return ListView(
              padding: EdgeInsets.fromLTRB(lrpadding, 32, lrpadding, 16),
              children: [
                const Divider(),
                const ListTile(
                  dense: true,
                  title: Text(
                    'Api Key',
                    textScaler: TextScaler.linear(1.5),
                  ),
                ),
                ...[
                  for (final apiKey in controller.keyControllers.entries)
                    RadiusTextFormField(
                      controller: apiKey.value,
                      labelText: apiKey.key,
                    )
                ],
                ElevatedButton(
                    onPressed: () => controller
                        .setApiKeyFromControllers(controller.keyControllers),
                    child: Text(
                      'updateKey'.tr,
                    )),
                const Divider(),
                SwitchListTile(
                  title: const Text('使用流式传输'),
                  value: controller.useStream, 
                  onChanged: controller.setUseStream,
                ),
                const Divider(),
                ListTile(
                  dense: true,
                  title: Text(
                    'theme'.tr,
                    textScaler: const TextScaler.linear(1.5),
                  ),
                ),
                RadioListTile(
                  title: Text('followSystem'.tr),
                  value: ThemeMode.system,
                  groupValue: controller.themeMode,
                  onChanged: (value) {
                    controller.setThemeMode(ThemeMode.system);
                  },
                ),
                RadioListTile(
                  title: Text('darkMode'.tr),
                  value: ThemeMode.dark,
                  groupValue: controller.themeMode,
                  onChanged: (value) {
                    controller.setThemeMode(ThemeMode.dark);
                  },
                ),
                RadioListTile(
                  title: Text('whiteMode'.tr),
                  value: ThemeMode.light,
                  groupValue: controller.themeMode,
                  onChanged: (value) {
                    controller.setThemeMode(ThemeMode.light);
                  },
                ),
                const Divider(),
                ListTile(
                  dense: true,
                  title: Text(
                    'language'.tr,
                    textScaler: const TextScaler.linear(1.5),
                  ),
                ),
                RadioListTile(
                  title: Text('zh'.tr),
                  value: 'zh',
                  groupValue: controller.localeText,
                  onChanged: (value) {
                    controller.setLocale(const Locale('zh'));
                  },
                ),
                RadioListTile(
                  title: Text('en'.tr),
                  value: 'en',
                  groupValue: controller.localeText,
                  onChanged: (value) {
                    controller.setLocale(const Locale('en'));
                  },
                ),
                ...controller.isLogin
                    ? [
                        const Divider(),
                        ElevatedButton(
                          onPressed: controller.logout,
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Get.context!.theme.colorScheme.error)),
                          child: Text('logout'.tr),
                        ),
                      ]
                    : []
              ],
            );
          }),
    );
  }
}
