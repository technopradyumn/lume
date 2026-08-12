import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.bgPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentStart,
      secondary: AppColors.accentEnd,
      surface: AppColors.bgSurface,
      error: AppColors.danger,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
      outline: AppColors.borderDefault,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.bgSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderDefault),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bgSurface,
      selectedItemColor: AppColors.accentGlow,
      unselectedItemColor: AppColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accentStart, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 14),
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.accentStart,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.borderDefault),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.2),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.2),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.6),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.6),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textTertiary),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
      labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textTertiary, letterSpacing: 0.5),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.borderDefault,
      thickness: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.bgElevated,
      selectedColor: AppColors.accentStart,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      side: const BorderSide(color: AppColors.borderDefault),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.bgSurface,
      contentTextStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );

  static ThemeData get lightTheme => darkTheme.copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBgPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.accentStart,
      secondary: AppColors.accentEnd,
      surface: AppColors.lightBgSurface,
      error: AppColors.danger,
      onPrimary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
      outline: Color(0x26475569),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightBgSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0x26475569)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightBgSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0x26475569)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0x26475569)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accentStart, width: 2),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBgSurface,
      selectedItemColor: AppColors.accentStart,
      unselectedItemColor: AppColors.lightTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
