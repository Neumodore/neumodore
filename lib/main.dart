import 'dart:io';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:neumodore/app/features/splashscreen/splashscreen.dart';
import 'package:neumodore/infra/controllers/ads_controller.dart';
import 'package:neumodore/infra/services/deep_links.dart';
import 'package:neumodore/infra/services/iap_service.dart';
import 'package:neumodore/pages.dart';
import 'package:neumodore/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'infra/translation.dart';

void main() async {
  // Initialize database
  WidgetsFlutterBinding.ensureInitialized();

  Get.put<SharedPreferences>(
    await SharedPreferences.getInstance(),
    permanent: true,
  );
  Get.put<DeepLinkService>(
    await DeepLinkService().initUniLinks(),
    permanent: true,
  );
  Get.put<AdsController>(AdsController(), permanent: true);
  Get.put<IAPService>(IAPService(), permanent: true);

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
      initialRoute: IntroScreen.route,
      theme: NeumodoreThemes.light(),
      darkTheme: NeumodoreThemes.dark(),
      // home: CheckScreen(), // (predatorx7) Used to test user issues.
    );
  }
}
