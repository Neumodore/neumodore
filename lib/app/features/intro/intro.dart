import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:neumodore/infra/controllers/settings_controller/settings_controller.dart';
import 'package:neumodore/infra/controllers/splashcreen_controller/splashscreen_controller.dart';
import 'package:neumodore/themes.dart';

class IntroScreen extends StatelessWidget {
  static String route = '/intro';

  // ignore: unused_field
  final SettingsController _settingsCtrl = Get.find();
  final SplashScreenController _splashScreenController = Get.find();

  @override
  Widget build(context) => TweenAnimationBuilder(
        duration: Duration(seconds: 1),
        tween: Tween<double>(begin: 0, end: 1),
        curve: Curves.easeInOutCubic,
        child: Container(),
        builder: (ctx, value, widget) {
          return Scaffold(
            backgroundColor: Color.lerp(
              NeumodoreThemes.light().backgroundColor,
              Get.theme.backgroundColor,
              value,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildQuote(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    _buildAuthor(context),
                  ],
                ),
              ),
            ),
          );
        },
      );

  AnimatedOpacity _buildQuote(BuildContext context) {
    return AnimatedOpacity(
      opacity: _splashScreenController.randomQuote.quote.isEmpty ? 0 : 1,
      duration: Duration(seconds: 2),
      curve: Curves.easeInOutCirc,
      child: Text(
        _splashScreenController.randomQuote.quote,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: Colors.grey[600]),
      ),
    );
  }

  AnimatedOpacity _buildAuthor(BuildContext context) {
    return AnimatedOpacity(
      opacity: _splashScreenController.randomQuote.authorName.isEmpty ? 0 : 1,
      duration: Duration(seconds: 3),
      curve: Curves.easeInOutCirc,
      child: Text(
        _splashScreenController.randomQuote.authorName.trim(),
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(color: Colors.grey[600]),
      ),
    );
  }
}
