import 'dart:io';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:neumodore/routes.dart';
import 'package:neumodore/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neumodore/infra/repositories/app_repository.dart';

void main() async {
  // Initialize database
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<SharedPreferences>(
    await SharedPreferences.getInstance(),
    permanent: true,
  );
  runApp(NeumodoreApp());
}

class NeumodoreApp extends StatelessWidget {
  final appState = Get.lazyPut<AppStateRepository>(
    () => AppStateRepository(Get.find()),
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
          'title': 'Neumodore',
          'settings_title': 'Settings',
          'enable_night_mode': 'Enable night mode',
          'durations_section': 'Durations',
          'pomodore_duration': 'Pomodore minutes',
          'shortbreak_duration': 'Shortbreak minutes',
          'longbreak_duration': 'Longbreak minutes',
          'appearence_section': 'Aparência',
        },
        'pt_BR': {
          'title': 'Neumodoro',
          'settings_title': 'Configurações',
          'enable_night_mode': 'Ativar tema noturno',
          'durations_section': 'Durações',
          'pomodore_duration': 'Minutos do Pomodoro',
          'shortbreak_duration': 'Minutos da pausa curta',
          'longbreak_duration': 'Minutos da pausa longa',
          'appearence_section': 'Aparência',
        },
      };
}
