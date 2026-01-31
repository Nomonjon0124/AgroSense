import 'package:flutter/material.dart';

/// Ilova uchun global ranglar
abstract class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primarySurface = Color(0xFFE8F5E9);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Weather Card Gradient
  static const Color weatherGradientStart = Color(0xFF2E7D32);
  static const Color weatherGradientEnd = Color(0xFF1B5E20);

  // Icon Colors
  static const Color iconActive = Color(0xFF1B5E20);
  static const Color iconInactive = Color(0xFF757575);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Shadow Color
  static Color shadow = Colors.black.withAlpha(10);
  static Color shadowDark = Colors.black.withAlpha(26);

  // Offline/Online Status
  static const Color online = Color(0xFF4CAF50);
  static const Color offline = Color(0xFF9E9E9E);

  // Weather Condition Colors
  static const Color sunny = Color(0xFFFFB300);
  static const Color cloudy = Color(0xFF78909C);
  static const Color rainy = Color(0xFF42A5F5);
  static const Color stormy = Color(0xFF5C6BC0);
}
