import 'package:flutter/material.dart';

// app_theme.dart

import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Cores
// ─────────────────────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  // ── Ramp principal: Ouro/Nude ──────────────────────────────────────────────
  static const Color primary = Color(0xFFC9A96E); // Ouro
  static const Color primaryLight = Color(0xFFEDD9B8); // Areia
  static const Color primaryDark = Color(0xFF5C4020); // Cacau
  static const Color onPrimary = Color(0xFF1A1208); // Espresso

  // ── Neutros ───────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFFAF6EF); // Creme
  static const Color surface = Color(0xFFF3EDE3); // Creme escuro
  static const Color surfaceVariant = Color(0xFFEDD9B8); // Areia

  // ── Texto ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1208); // Espresso
  static const Color textSecondary = Color(0xFF5C4020); // Cacau
  static const Color textHint = Color(0xFFC9A96E); // Ouro

  // ── Feedback ──────────────────────────────────────────────────────────────
  static const Color error = Color(0xFF7A1111);
  static const Color success = Color(0xFF3A7D44);

  // ── Dark mode ─────────────────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF1A1208); // Espresso
  static const Color surfaceDark = Color(0xFF2A1E0F); // Espresso claro
  static const Color surfaceVariantDark = Color(0xFF3D2B14);
}

// ─────────────────────────────────────────────────────────────────────────────
// Tipografia  (google_fonts: ^6.x)
// ─────────────────────────────────────────────────────────────────────────────

class AppTextStyles {
  AppTextStyles._();

  // Cormorant Garamond — serifada editorial para títulos
  // Jost — sem serifa moderna para corpo
  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.cormorantGaramond(
      fontSize: 48,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
    ),
    displayMedium: GoogleFonts.cormorantGaramond(
      fontSize: 36,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: GoogleFonts.cormorantGaramond(
      fontSize: 28,
      fontWeight: FontWeight.w500,
    ),
    headlineLarge: GoogleFonts.cormorantGaramond(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.cormorantGaramond(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: GoogleFonts.jost(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
    titleLarge: GoogleFonts.jost(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    titleMedium: GoogleFonts.jost(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    titleSmall: GoogleFonts.jost(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.jost(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.6,
    ),
    bodyMedium: GoogleFonts.jost(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.jost(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    labelLarge: GoogleFonts.jost(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
    labelMedium: GoogleFonts.jost(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
    ),
    labelSmall: GoogleFonts.jost(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.4,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Tema
// ─────────────────────────────────────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _build(
    scheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.onPrimary,
      secondary: AppColors.primaryDark,
      onSecondary: AppColors.background,
      secondaryContainer: AppColors.surfaceVariant,
      onSecondaryContainer: AppColors.onPrimary,
      tertiary: AppColors.textHint,
      onTertiary: AppColors.onPrimary,
      tertiaryContainer: AppColors.primaryLight,
      onTertiaryContainer: AppColors.onPrimary,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: Color(0xFFFADDDD),
      onErrorContainer: Color(0xFF7A1F1F),
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.primaryLight,
      outlineVariant: AppColors.surfaceVariant,
      shadow: AppColors.onPrimary,
      scrim: AppColors.onPrimary,
      inverseSurface: AppColors.onPrimary,
      onInverseSurface: AppColors.background,
      inversePrimary: AppColors.primaryLight,
    ),
  );

  static ThemeData get darkTheme => _build(
    scheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryLight, // Areia vira o primary no dark
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.primaryLight,
      secondary: AppColors.primary, // Ouro
      onSecondary: AppColors.onPrimary,
      secondaryContainer: AppColors.surfaceVariantDark,
      onSecondaryContainer: AppColors.primaryLight,
      tertiary: AppColors.primary,
      onTertiary: AppColors.onPrimary,
      tertiaryContainer: AppColors.surfaceVariantDark,
      onTertiaryContainer: AppColors.primaryLight,
      error: Color(0xFFE07070),
      onError: Color(0xFF4A1515),
      errorContainer: Color(0xFF6E2020),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: AppColors.surfaceDark,
      onSurface: AppColors.primaryLight,
      surfaceContainerHighest: AppColors.surfaceVariantDark,
      onSurfaceVariant: AppColors.primary,
      outline: AppColors.primaryDark,
      outlineVariant: AppColors.surfaceVariantDark,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.primaryLight,
      onInverseSurface: AppColors.onPrimary,
      inversePrimary: AppColors.primaryDark,
    ),
  );

  static ThemeData _build({required ColorScheme scheme}) {
    final isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTextStyles.textTheme,

      scaffoldBackgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.background,

      // ── AppBar ─────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.background,
        foregroundColor: isDark ? AppColors.primaryLight : AppColors.onPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.cormorantGaramond(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.primaryLight : AppColors.onPrimary,
          letterSpacing: 0.2,
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.primaryLight : AppColors.onPrimary,
        ),
      ),

      // ── Card ───────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark
                ? AppColors.surfaceVariantDark
                : AppColors.surfaceVariant,
            width: 0.5,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── FilledButton ───────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle: GoogleFonts.jost(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
        ),
      ),

      // ── OutlinedButton ─────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark
              ? AppColors.primaryLight
              : AppColors.primaryDark,
          side: BorderSide(
            color: isDark ? AppColors.primary : AppColors.primaryDark,
            width: 1,
          ),
          textStyle: GoogleFonts.jost(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      // ── TextButton ─────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.jost(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── InputDecoration ────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.surfaceVariantDark
            : AppColors.surfaceVariant.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.surfaceVariantDark
                : AppColors.primaryLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.surfaceVariantDark
                : AppColors.primaryLight,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        labelStyle: GoogleFonts.jost(
          color: isDark ? AppColors.primary : AppColors.textSecondary,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.jost(
          color: isDark
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.textHint.withOpacity(0.6),
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      // ── BottomNavigationBar ────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: isDark
            ? AppColors.primary.withOpacity(0.4)
            : AppColors.textSecondary.withOpacity(0.5),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // ── Chip ───────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? AppColors.surfaceVariantDark
            : AppColors.surfaceVariant,
        selectedColor: AppColors.primary.withOpacity(0.2),
        labelStyle: GoogleFonts.jost(fontSize: 12, fontWeight: FontWeight.w500),
        side: BorderSide(
          color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
          width: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),

      // ── Divider ────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant,
        thickness: 0.5,
        space: 0,
      ),

      // ── SnackBar ───────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.primaryLight : AppColors.onPrimary,
        contentTextStyle: GoogleFonts.jost(
          color: isDark ? AppColors.onPrimary : AppColors.background,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
