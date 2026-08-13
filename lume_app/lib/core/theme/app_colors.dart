import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const bgPrimary = Color(0xFF0A0A0F);
  static const bgSurface = Color(0xFF13131D);
  static const bgElevated = Color(0xFF1C1C2E);
  static const bgHover = Color(0xFF252540);

  static const accentStart = Color(0xFF8B5CF6);
  static const accentEnd = Color(0xFF6366F1);
  static const accentGlow = Color(0xFFA78BFA);
  static const accentMuted = Color(0x268B5CF6);

  static const textPrimary = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF94A3B8);
  static const textTertiary = Color(0xFF64748B);

  static const success = Color(0xFF10B981);
  static const danger = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);

  static const borderDefault = Color(0x1A8B5CF6);
  static const borderHover = Color(0x408B5CF6);

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentStart, accentEnd],
  );

  static const lightBgPrimary = Color(0xFFF8FAFC);
  static const lightBgSurface = Color(0xFFFFFFFF);
  static const lightBgElevated = Color(0xFFF1F5F9);
  static const lightTextPrimary = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF475569);
}
