import 'package:flutter/material.dart';
import 'package:safqaseller/core/utils/app_color.dart';

/// Centralized light and dark [ThemeData] definitions.
///
/// Both themes share the same sizing / font-family (injected per-locale)
/// and only differ in colors.
abstract class AppTheme {
  // ───────────────────────── LIGHT ─────────────────────────
  static ThemeData lightTheme(String fontFamily) {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: fontFamily,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.lightScaffold,
      cardColor: AppColors.lightCard,
      dividerColor: AppColors.lightDivider,
      hintColor: AppColors.lightHint,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        surface: AppColors.lightSurface,
        onPrimary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
        onSecondary: AppColors.primaryColor,
        outline: AppColors.lightBorder,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightScaffold,
        foregroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightsecondaryColor,
        hintStyle: const TextStyle(color: AppColors.lightHint),
        border: _buildInputBorder(AppColors.lightBorder),
        enabledBorder: _buildInputBorder(AppColors.lightBorder),
        focusedBorder: _buildInputBorder(AppColors.primaryColor),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightScaffold,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.lightHint,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.lightScaffold,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightScaffold,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.primaryColor,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  // ───────────────────────── DARK ──────────────────────────
  static ThemeData darkTheme(String fontFamily) {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      primaryColor: AppColors.darkPrimaryColor,
      scaffoldBackgroundColor: AppColors.darkScaffold,
      cardColor: AppColors.darkCard,
      dividerColor: AppColors.darkDivider,
      hintColor: AppColors.darkHint,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimaryColor,
        secondary: AppColors.darkSecondaryColor,
        surface: AppColors.darkSurface,
        onPrimary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
        onSecondary: AppColors.darkTextPrimary,
        outline: AppColors.darkBorder,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkPrimaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkPrimaryColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        hintStyle: const TextStyle(color: AppColors.darkHint),
        border: _buildInputBorder(AppColors.darkBorder),
        enabledBorder: _buildInputBorder(AppColors.darkBorder),
        focusedBorder: _buildInputBorder(AppColors.darkPrimaryColor),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkPrimaryColor,
        unselectedItemColor: AppColors.darkHint,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.darkSurface,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.darkPrimaryColor,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  // ─────────────────── shared helpers ───────────────────
  static OutlineInputBorder _buildInputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(width: 1, color: color),
    );
  }
}
