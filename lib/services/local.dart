import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalService extends GetxService {
  final GetStorage _box = GetStorage();

  String _userName = '';
  late Locale _local;
  late ThemeMode _theme;
  late bool _useStream;

  String get userName {
    return _userName;
  }
  bool get isLogin => _userName != '';
  set userName(String value) {
    _userName = value;
    _box.write('userName', value);
  }

  Locale get local => _local;
  set local(Locale local) {
    Get.updateLocale(local);
    _local = local;
    _box.write('locale', local.languageCode);
  }

  ThemeMode get theme => _theme;
  set theme(ThemeMode theme) {
    _theme = theme;
    _box.write('theme', theme.toString().split('.')[1]);
  }

  bool get useStream => _useStream;
  set useStream(bool useStream) {
    _useStream = useStream;
    _box.write('useStream', useStream);
  }


  @override
  void onInit() async {
    super.onInit();
    initLocal();
    initUser();
    initTheme();
    initUseStream();
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

  initUseStream() async {
    _useStream = _box.read('useStream') ?? false;
  }
}
