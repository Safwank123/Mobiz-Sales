import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.kAppPrimary,
        primary: AppColors.kAppPrimary,
        secondary: AppColors.kAppSecondary,
        surface: AppColors.kAppCardColor,
        error: AppColors.kAppError,
      ).copyWith(
        surface: AppColors.kAppBackground,
      ),
      scaffoldBackgroundColor: AppColors.kAppBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.kAppPrimary,
        foregroundColor: AppColors.kAppWhite,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kAppPrimary,
          foregroundColor: AppColors.kAppWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.kAppWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.kAppBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.kAppBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.kAppPrimary),
        ),
      ),
    );
  }
}
