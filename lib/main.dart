import 'dart:io';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:neumodore/routes.dart';
import 'package:neumodore/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neumodore/infra/repositories/app_repository.dart';

void main() {
  runApp(NeumodoreApp());
}

class NeumodoreApp extends StatelessWidget {
  final appState = Get.lazyPut<AppStateRepository>(
    () => AppStateRepository(SharedPreferences.getInstance()),
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: NeumodoreThemes.dark().backgroundColor,
    ));

    return GetMaterialApp(
      title: 'Neumodore',
      debugShowCheckedModeBanner: false,
      getPages: routes,
      translations: NeumodoreTranslations(),
      locale: Locale(
        Platform.localeName.split('_')[0],
        Platform.localeName.split('_')[1],
      ),
      initialRoute: '/intro',
      theme: NeumodoreThemes.light(),
      darkTheme: NeumodoreThemes.dark(),
      // home: CheckScreen(), // (predatorx7) Used to test user issues.
    );
  }
}

class NeumodoreTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'title': 'Hello World %s',
          'settings_title': 'Settings',
          'enable_night_mode': 'Enable night mode',
        },
        'pt_BR': {
          'title': 'Olá do Brasil',
          'settings_title': 'Configurações',
          'enable_night_mode': 'Ativar tema noturno',
        },
      };
}
