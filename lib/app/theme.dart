import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// LingoDash Design Tokens
/// All colors, fonts, and radii are centralized here.
/// NEVER hardcode these values directly in screens.

// =============================================================================
// COLORS
// =============================================================================

class AppColors {
  // Primary
  static const Color primary = Color(0xFF2B6CEE);

  // Backgrounds
  static const Color darkBg = Color(0xFF101622);
  static const Color darkBgAlt = Color(0xFF0F172A);
  static const Color lightBg = Color(0xFFF6F6F8);

  // Call buttons
  static const Color callGreen = Color(0xFF22C55E);
  static const Color callRed = Color(0xFFEF4444);

  // Kakao login
  static const Color kakaoBg = Color(0xFFFEE500);
  static const Color kakaoText = Color(0xFF191919);

  // Chat bubbles
  static const Color aiBubbleLight = Color(0xFFF1F1F4);
  static const Color aiBubbleDark = Color(0xFF1E293B);
  static const Color userBubble = Color(0xFF2B6CEE);

  // Level colors (learning activity heatmap)
  static const List<Color> levelColors = [
    Color(0xFFF1F5F9),
    Color(0xFFDBEAFE),
    Color(0xFF93C5FD),
    Color(0xFF3B82F6),
    Color(0xFF1D4ED8),
  ];

  // Grays/Slate (commonly used)
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // Text colors
  static const Color textDark = Color(0xFF1E293B);
  static const Color textLight = Colors.white;
}

// =============================================================================
// BORDER RADIUS
// =============================================================================

class AppRadius {
  static const double full = 9999; // Pills - buttons, chips, tabs
  static const double xxl = 24; // Large cards
  static const double xl = 16; // Regular cards, input fields
  static const double lg = 12;
  static const double md = 8;
}

// =============================================================================
// SHADOWS / ELEVATION
// =============================================================================

class AppShadows {
  static BoxShadow get cardShadow => BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 8,
        offset: const Offset(0, 2),
      );

  static BoxShadow get primaryShadow => const BoxShadow(
        color: Color(0x332B6CEE),
        blurRadius: 12,
        offset: Offset(0, 4),
      );

  static BoxShadow get redShadow => BoxShadow(
        color: Colors.red.withValues(alpha: 0.2),
        blurRadius: 12,
        offset: const Offset(0, 4),
      );
}

// =============================================================================
// TYPOGRAPHY
// =============================================================================

class AppTextStyles {
  // Display / Hero: 28-32px, weight 700
  static TextStyle displayHero({Color? color}) => GoogleFonts.lexend(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textDark,
      );

  // Title Large: 24px, weight 700
  static TextStyle titleLarge({Color? color}) => GoogleFonts.lexend(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textDark,
      );

  // Title Medium: 18-20px, weight 600-700
  static TextStyle titleMedium({Color? color}) => GoogleFonts.lexend(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textDark,
      );

  // Body Large: 16px, weight 400-500
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.lexend(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textDark,
      );

  // Body Medium: 14-15px, weight 400-500
  static TextStyle bodyMedium({Color? color}) => GoogleFonts.lexend(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textDark,
      );

  // Body Small: 13px, weight 400
  static TextStyle bodySmall({Color? color}) => GoogleFonts.lexend(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textDark,
      );

  // Label Large: 12px, weight 600-700
  static TextStyle labelLarge({Color? color}) => GoogleFonts.lexend(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textDark,
      );

  // Label Small / Caption: 10-11px, weight 500-700, uppercase, wide tracking
  static TextStyle labelSmall({Color? color}) => GoogleFonts.lexend(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: color ?? AppColors.textDark,
      );
}

// =============================================================================
// THEME DATA
// =============================================================================

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.lightBg,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.primary,
          surface: Colors.white,
          error: AppColors.callRed,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.lightBg,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTextStyles.titleMedium(),
          iconTheme: const IconThemeData(color: AppColors.textDark),
        ),
        textTheme: TextTheme(
          displayLarge: AppTextStyles.displayHero(),
          titleLarge: AppTextStyles.titleLarge(),
          titleMedium: AppTextStyles.titleMedium(),
          bodyLarge: AppTextStyles.bodyLarge(),
          bodyMedium: AppTextStyles.bodyMedium(),
          bodySmall: AppTextStyles.bodySmall(),
          labelLarge: AppTextStyles.labelLarge(),
          labelSmall: AppTextStyles.labelSmall(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: AppTextStyles.bodyLarge(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textDark,
            side: const BorderSide(color: AppColors.slate200),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            borderSide: const BorderSide(color: AppColors.slate200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            borderSide: const BorderSide(color: AppColors.slate200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.darkBg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.primary,
          surface: AppColors.darkBgAlt,
          error: AppColors.callRed,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkBg,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTextStyles.titleMedium(color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        textTheme: TextTheme(
          displayLarge: AppTextStyles.displayHero(color: Colors.white),
          titleLarge: AppTextStyles.titleLarge(color: Colors.white),
          titleMedium: AppTextStyles.titleMedium(color: Colors.white),
          bodyLarge: AppTextStyles.bodyLarge(color: Colors.white),
          bodyMedium: AppTextStyles.bodyMedium(color: Colors.white),
          bodySmall: AppTextStyles.bodySmall(color: Colors.white),
          labelLarge: AppTextStyles.labelLarge(color: Colors.white),
          labelSmall: AppTextStyles.labelSmall(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: AppTextStyles.bodyLarge(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: AppColors.slate600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkBgAlt,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            borderSide: const BorderSide(color: AppColors.slate600),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            borderSide: const BorderSide(color: AppColors.slate600),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkBgAlt,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
        ),
      );
}
