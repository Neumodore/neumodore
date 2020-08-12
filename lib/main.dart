import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neumodore/routes.dart';
import 'package:neumodore/themes.dart';

void main() {
  runApp(NeumodoreApp());
}

Color _color = Color(0xFFf2f2f2); // Colors.grey[200]

class NeumodoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: _color,
    ));

    return GetMaterialApp(
      title: 'Neumodore',
      debugShowCheckedModeBanner: false,
      getPages: routes,
      initialRoute: '/home',
      themeMode: ThemeMode.system,
      theme: NeumodoreThemes.light(),
      // home: CheckScreen(), // (predatorx7) Used to test user issues.
    );
  }
}

class NeumodoreTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'title': 'Hello World %s',
        },
        'pt_BR': {
          'title': 'Olá do Brasil',
        },
      };
}
