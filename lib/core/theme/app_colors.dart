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
  static const Color background = Color(0xFFF2F5F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);
  static const Color glassSurface = Color(0xE6FFFFFF);
  static const Color darkBackground = Color(0xFF0F1512);
  static const Color darkSurface = Color(0xFF18201B);
  static const Color darkSurfaceVariant = Color(0xFF212A24);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textPrimaryDark = Color(0xFFEAF3EC);
  static const Color textSecondaryDark = Color(0xFFB6C4BC);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color critical = Color(0xFFD32F2F);
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
  static const Color borderSoft = Color(0xFFE2E8F0);

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
