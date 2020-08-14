import 'package:flutter/material.dart';

class NeumodoreThemes {
  static ThemeData dark() {
    var darkBlueBackgroundColor = Color(0xFF1c1f27);
    return ThemeData.dark().copyWith(
      backgroundColor: darkBlueBackgroundColor,
      scaffoldBackgroundColor: darkBlueBackgroundColor,
    );
  }

  static ThemeData light() {
    final lightGreyBackgroundColor = Color(0xFFefeeee);
    return ThemeData.light().copyWith(
      platform: TargetPlatform.iOS,
      accentColor: Colors.grey,
      colorScheme: ColorScheme.light(),
      backgroundColor: lightGreyBackgroundColor,
      scaffoldBackgroundColor: lightGreyBackgroundColor,
      dialogBackgroundColor: Colors.grey[300],
      appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        color: lightGreyBackgroundColor,
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
    );
  }
}
