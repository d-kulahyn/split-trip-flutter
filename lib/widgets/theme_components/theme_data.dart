import 'package:split_trip/constants/theme_constants.dart';
import 'package:flutter/material.dart';

ThemeData buildTheme() {
  return ThemeData(
    fontFamily: 'SF UI Display',
    scaffoldBackgroundColor: Colors.white,
    splashFactory: NoSplash.splashFactory,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: Colors.black,
        textStyle: const TextStyle(
          fontSize: cTextFormFieldFontSize,
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 14.0, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 12.0, color: Colors.black),
      bodySmall: TextStyle(fontSize: 10.0, color: Colors.black),
      titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
      titleMedium: TextStyle(fontSize: 16.0, color: Colors.black),
      titleSmall: TextStyle(fontSize: 16.0, color: Colors.black),
      headlineLarge: TextStyle(fontSize: 16.0, color: Colors.black),
      headlineMedium: TextStyle(fontSize: 16.0, color: Colors.black),
      headlineSmall: TextStyle(fontSize: 16.0, color: Colors.black),
      labelLarge: TextStyle(fontSize: 16.0, color: Colors.black),
      labelMedium: TextStyle(fontSize: 16.0, color: Colors.black),
      labelSmall: TextStyle(fontSize: 16.0, color: Colors.black),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(fontSize: cTextFormFieldFontSize, color: Colors.black),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(fontSize: 18.0),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color.fromRGBO(230, 230, 230, 1), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(cTextFormFieldBorderRadius),
      ),
    ),
  );
}
