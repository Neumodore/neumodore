import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/domain/data/quote_model.dart';
import 'package:neumodore/infra/repositories/theme/itheme_repository.dart';
import 'package:neumodore/infra/services/phrase_service.dart';

class SplashScreenController extends GetxController {
  final IThemeRepository themeRepository;
  final PhraseService phraseService;

  SplashScreenController(this.themeRepository, this.phraseService);

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Quote _quote = Quote.fromArray(['', '']);
  Quote get randomQuote => _quote;

  @override
  void onInit() async {
    super.onInit();
    _quote = await PhraseService().fetchRandomPhrase();

    Future.delayed(Duration(milliseconds: 10), () {
      print({"Theme mode setted": themeRepository.getThemeMode()});
      Get.changeThemeMode(themeRepository.getThemeMode());
    });
    update();

    Future.delayed(Duration(milliseconds: _quote.millisNeedToRead()), () {
      Get.offAllNamed("/home");
    });
  }
}
