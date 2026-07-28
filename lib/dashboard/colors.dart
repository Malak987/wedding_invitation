import 'package:flutter/material.dart';

/// ============================================================
/// COLOR PALETTE — Local Dashboard
/// ============================================================
/// Change the hex values only. All widgets read from here.
/// ============================================================

class AppColorsData {
  AppColorsData._();

  static const Color primary = Color(0xFFC9A66B); // gold
  static const Color secondary = Color(0xFF6B4F3B); // deep brown
  static const Color accent = Color(0xFFE8C39E); // soft peach

  static const Color background = Color(0xFFFFF9F3);
  static const Color backgroundDark = Color(0xFF241C15);

  static const Color textPrimary = Color(0xFF2E241B);
  static const Color textSecondary = Color(0xFF6E5D4C);
  static const Color textOnDark = Color(0xFFFFF9F3);

  static const Color buttonColor = Color(0xFFC9A66B);
  static const Color buttonTextColor = Color(0xFFFFFFFF);

  static const Color glassFill = Color(0x33FFFFFF);
  static const Color glassBorder = Color(0x55FFFFFF);

  static const Color divider = Color(0xFFD8C4A8);
  static const Color shadow = Color(0x33000000);

  static const List<Color> heroGradient = [
    Color(0xFFFFF3E4),
    Color(0xFFF3E1C7),
  ];
}
