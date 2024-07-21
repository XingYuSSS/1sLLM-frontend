import 'package:get/get.dart';

import 'package:ones_llm/pages/home.dart';
import 'package:ones_llm/pages/login.dart';
import 'package:ones_llm/pages/setting.dart';


final routes = [
  GetPage(name: '/', page: () => MyHomePage()),
  GetPage(name: '/home', page: () => MyHomePage()),
  GetPage(name: '/login', page: () => LoginPage()),
  GetPage(name: '/setting', page: () => SettingPage())
];