import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

late final Directory appCacheDir;
late final Directory appDocDir;

late final String apiBaseUrl;

Future initVar() async {
  await dotenv.load(fileName: ".env");
  apiBaseUrl = dotenv.env['apiBaseUrl']!;
  if(!kIsWeb){
    appCacheDir = await getApplicationCacheDirectory();
    appDocDir = await getApplicationDocumentsDirectory();
    print(appCacheDir);
    print(appDocDir);
  } else {
    
  }
}