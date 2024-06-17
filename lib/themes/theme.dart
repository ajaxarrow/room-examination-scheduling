import 'package:flutter/material.dart';

import 'colors.dart';

final ColorScheme kColorScheme = ColorScheme.fromSeed(seedColor: primaryColor);


var appTheme = ThemeData(
  useMaterial3: false,
  fontFamily: 'Cabinet',
  colorScheme: kColorScheme,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontFamily: 'Cabinet'),
    bodyMedium: TextStyle(fontFamily: 'Cabinet'),
    titleMedium: TextStyle(fontFamily: 'Cabinet', fontWeight: FontWeight.w600),
    titleLarge:  TextStyle(fontFamily: 'Cabinet', fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontFamily: 'Cabinet', fontWeight: FontWeight.w500),
    displayLarge: TextStyle(fontFamily: 'Cabinet'),
    displayMedium: TextStyle(fontFamily: 'Cabinet'),
    displaySmall: TextStyle(fontFamily: 'Cabinet'),
    headlineMedium: TextStyle(fontFamily: 'Cabinet'),
    headlineSmall: TextStyle(fontFamily: 'Cabinet'),
    headlineLarge: TextStyle(fontFamily: 'Cabinet'),
    bodySmall: TextStyle(fontFamily: 'Cabinet'),
    labelLarge: TextStyle(fontFamily: 'Cabinet', fontSize: 16),
    labelMedium: TextStyle(fontFamily: 'Cabinet', fontSize: 16),
    labelSmall: TextStyle(fontFamily: 'Cabinet', fontSize: 13.5),
  ),
);