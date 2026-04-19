// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF12121C);
  static const Color surfaceVariant = Color(0xFF1A1A2E);
  static const Color surfaceLight = Color(0xFF1E1E32);

  // Primary palette
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFF9F5CF7);
  static const Color primaryDark = Color(0xFF5B21B6);
  static const Color secondary = Color(0xFFA855F7);

  // Accent
  static const Color accent = Color(0xFF06B6D4);
  static const Color accentGold = Color(0xFFF59E0B);

  // Text
  static const Color textPrimary = Color(0xFFF8F8FF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textSubtle = Color(0xFF6B7280);

  // Semantic
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  // Border & Divider
  static const Color border = Color(0xFF2D2D4A);
  static const Color divider = Color(0xFF1F1F35);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0A0F), Color(0xFF12121C)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF12121C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
