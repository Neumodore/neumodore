import 'dart:io';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:neumodore/routes.dart';
import 'package:neumodore/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          'pomodore': 'pomodore',
          'short_break': 'short break',
          'long_break': 'long break',
          'pomodore_duration': 'Pomodore minutes',
          'shortbreak_duration': 'Shortbreak minutes',
          'longbreak_duration': 'Longbreak minutes',
          'appearence_section': 'Appearence',
          'activity_ending': '%s will end!',
          'activity_ending_body': 'Less than 1 minute to end %s',
          'activity_ended': '%s ended!!',
          'activity_ended_body': 'The %s ended open the app to continue',
          'system_channel_name': 'Pomodore progress',
          'system_channel_desc':
              'Show notifications according pomodore progress',
        },
        'pt_BR': {
          'title': 'Neumodoro',
          'settings_title': 'Configurações',
          'enable_night_mode': 'Ativar tema noturno',
          'durations_section': 'Durações',
          'pomodore': 'pomodoro',
          'short_break': 'pausa curta',
          'long_break': 'pausa longa',
          'pomodore_duration': 'Minutos do Pomodoro',
          'shortbreak_duration': 'Minutos da pausa curta',
          'longbreak_duration': 'Minutos da pausa longa',
          'appearence_section': 'Aparência',
          'finsihed_activity': 'Sessão terminada',
          'activity_ending': '%s esta acabando!',
          'activity_ending_body': 'Menos de 1 minuto para %s terminar',
          'activity_ended': '%s terminou!!',
          'activity_ended_body': '%s terminou abra o app para continuar',
          'system_channel_name': 'Progresso do pomodoro',
          'system_channel_desc':
              'Exibe informações sobre o progresso do pomodoro',
        },
      };
}
