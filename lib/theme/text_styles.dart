import 'package:flutter/material.dart';
import '../dashboard/colors.dart';
import '../dashboard/fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle heroTitle = TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 56,
    fontWeight: FontWeight.w700,
    color: AppColorsData.textPrimary,
    height: 1.2,
  );

  static const TextStyle heroSubtitle = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColorsData.textSecondary,
    height: 1.6,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColorsData.textPrimary,
  );

  static const TextStyle sectionSubtitle = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColorsData.textSecondary,
    height: 1.7,
  );

  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColorsData.textPrimary,
    height: 1.6,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColorsData.buttonTextColor,
  );

  static const TextStyle countdownNumber = TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColorsData.primary,
  );

  static const TextStyle countdownLabel = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColorsData.textSecondary,
  );
}
