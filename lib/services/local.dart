import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalService extends GetxService {
  final GetStorage _box = GetStorage();

  String _userName = '';
  String get userName {
    return _userName;
  }

  set userName(String value) {
    _userName = value;
    _box.write('userName', value);
  }

  bool get isLogin => _userName != '';

  late Locale _local;
  Locale get local => _local;
  set local(Locale local) {
    Get.updateLocale(local);
    _local = local;
    _box.write('locale', local.languageCode);
  }

  late ThemeMode _theme;
  ThemeMode get theme => _theme;
  set theme(ThemeMode theme) {
    _theme = theme;
    _box.write('theme', theme.toString().split('.')[1]);
  }

  @override
  void onInit() async {
    super.onInit();
    initLocal();
    initUser();
    initTheme();
  }

  initLocal() async {
    Locale locale;
    String localeText = _box.read('locale') ?? 'zh';
    switch (localeText) {
      case 'en':
        locale = const Locale('en');
      case 'zh':
        locale = const Locale('zh');
      default:
        locale = Get.deviceLocale!;
    }
    local = locale;
  }

  initUser() async {
    _userName = _box.read('userName') ?? '';
  }

  initTheme() async {
    ThemeMode themeMode;
    String themeText = _box.read('theme') ?? 'system';
    try {
      themeMode =
          ThemeMode.values.firstWhere((e) => e.name == themeText);
    } catch (e) {
      themeMode = ThemeMode.system;
    }
    theme = themeMode;
  }
}
