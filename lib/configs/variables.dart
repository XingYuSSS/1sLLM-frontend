import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

late final Directory appCacheDir;
late final Directory appDocDir;

late final String apiBaseUrl;

late final bool singleModelMode;
late final String singleModelName;
late final String singleProviderName;

Future initVar() async {
  await dotenv.load(fileName: ".env");
  apiBaseUrl = dotenv.env['apiBaseUrl']!;

  singleModelMode = dotenv.env['singleModelMode']?.toLowerCase() == 'true';
  if (singleModelMode) {
    singleModelName = dotenv.env['singleModelName']!;
    singleProviderName = dotenv.env['singleProviderName']!;
  }
  
  if(!kIsWeb){
    appCacheDir = await getApplicationCacheDirectory();
    appDocDir = await getApplicationDocumentsDirectory();
  } else {
    
  }
}