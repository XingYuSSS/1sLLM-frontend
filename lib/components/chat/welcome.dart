import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Welcome extends StatelessWidget {
  final List<String> promptList;
  final void Function(String prompt) sendPrompt;

  const Welcome(
      {super.key, required this.promptList, required this.sendPrompt});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        Image.asset(
          'images/logo.png',
          width: 50,
          height: 50,
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'hello_title'.tr,
            style: Get.theme.textTheme.headlineMedium
                ?.apply(fontWeightDelta: 1, color: Get.theme.colorScheme.onBackground),
          ),
        ),
        const Divider(),
        const SizedBox(
          height: 5,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'hello_subtitle'.tr,
            style: Get.theme.textTheme.bodyLarge,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            constraints: const BoxConstraints(minWidth: 420, maxWidth: 420),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'hello_example'.tr,
                    style: Get.textTheme.titleMedium?.apply(
                      fontWeightDelta: 1,
                      fontSizeDelta: 2,
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                ...[
                  for (var prompt in promptList) ...[
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () => sendPrompt(prompt),
                        style: ButtonStyle(
                            alignment: Alignment.centerLeft,
                            fixedSize: const MaterialStatePropertyAll(
                                Size.fromWidth(400)),
                            backgroundColor: MaterialStatePropertyAll(
                                Get.theme.colorScheme.background.darken(2)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            foregroundColor:
                                MaterialStatePropertyAll(Get.theme.colorScheme.onBackground)),
                        child: Text('· $prompt'),
                      ),
                    ),
                  ]
                ],
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
