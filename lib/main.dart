import 'package:neumodore/app/features/home/home_page.dart';
import 'package:neumodore/data/activity/activity.dart';
import 'package:neumodore/data/pomodore_state.dart';
import 'package:neumodore/infra/controllers/pomodore_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neumodore/routes.dart';

void main() => runApp(NeumodoreApp());

Color _color = Color(0xFFf2f2f2); // Colors.grey[200]

class NeumodoreApp extends StatelessWidget {
  final PomodoreController _presenter =
      Get.put(PomodoreController(PomodoreState(PomodoreActivity())));

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
      themeMode: ThemeMode.light,
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        primarySwatch: Colors.grey,
        accentColor: Colors.grey,
        colorScheme: ColorScheme.light(),
        backgroundColor: Color.lerp(_color, Colors.black, 0.005),
        scaffoldBackgroundColor: _color,
        dialogBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: _color,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      getPages: routes,
      home: HomeScreen(),
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
