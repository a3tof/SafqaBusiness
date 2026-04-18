import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Brand colors (unchanged) ──
  static const Color primaryColor = Color(0xFF023E8A);
  static const Color lightPrimaryColor = Color(0xFF023E8A);
  static const Color secondaryColor = Color(0xFFE6F1FF);
  static const Color lightsecondaryColor = Color(0xFFFFFFFF);

  // ── Dark-mode brand tint (lighter for contrast on dark surfaces) ──
  static const Color darkPrimaryColor = Color(0xFF3A7BD5);

  // ── Light-mode semantic tokens ──
  static const Color lightScaffold = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE6E9E9);
  static const Color lightDivider = Color(0xFFE6E9E9);
  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF808080);
  static const Color lightHint = Color(0xFF949D9E);

  // ── Dark-mode semantic tokens ──
  static const Color darkScaffold = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF252525);
  static const Color darkBorder = Color(0xFF333333);
  static const Color darkDivider = Color(0xFF333333);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);
  static const Color darkHint = Color(0xFF757575);
  static const Color darkSecondaryColor = Color(0xFF1A2D42);
}
