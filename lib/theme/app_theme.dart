import 'package:flutter/material.dart';
import '../dashboard/colors.dart';
import '../dashboard/fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColorsData.background,
      fontFamily: AppFonts.body,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColorsData.primary,
        primary: AppColorsData.primary,
        secondary: AppColorsData.secondary,
        surface: AppColorsData.background,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColorsData.primary,
        selectionColor: AppColorsData.accent,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
