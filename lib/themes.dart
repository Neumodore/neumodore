import 'package:flutter/material.dart';

class NeumodoreThemes {
  static ThemeData dark() => ThemeData.dark().copyWith(
        backgroundColor: Color(0xFF1c1f27),
      );

  static ThemeData light() {
    final lightGreyBackgroundColor = Color(0xFFefeeee);
    return ThemeData.light().copyWith(
      platform: TargetPlatform.iOS,
      accentColor: Colors.grey,
      colorScheme: ColorScheme.light(),
      backgroundColor: lightGreyBackgroundColor,
      scaffoldBackgroundColor: Color(0xFFefeeee),
      dialogBackgroundColor: Colors.grey[300],
      appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        color: Color(0xFFefeeee),
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
