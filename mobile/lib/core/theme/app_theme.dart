import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design system DuoDay (UI/UX) — paleta, tipografia Inter e componentes base.
class AppTheme {
  /* ---------- Paleta ---------- */
  static const Color primaryColor = Color(0xFF6A5CFF);
  static const Color primarySecondary = Color(0xFF8E7BFF);
  static const Color accentPink = Color(0xFFFF5C8D);

  static const Color background = Color(0xFFF7F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1D1B36);
  static const Color textSecondary = Color(0xFF6B6B8D);
  static const Color textTertiary = Color(0xFF9CA3AF);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFFF4D4F);
  static const Color info = Color(0xFF60A5FA);

  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color shadowColor = Color(0x14000000);

  /// Gráficos / finanças (roxo, rosa, azul claro)
  static const Color chartPurple = Color(0xFF6A5CFF);
  static const Color chartPink = Color(0xFFFF5C8D);
  static const Color chartBlueLight = Color(0xFF93C5FD);

  static const Color heart = Color(0xFFFF5C8D);
  static const Color connected = Color(0xFF22C55E);
  static const Color pending = Color(0xFFF59E0B);

  static const Color disabledButton = Color(0xFFE5E7EB);

  /* Aliases usados no código legado */
  static const Color primaryLight = primarySecondary;
  static const Color primaryDark = Color(0xFF5548E6);
  static const Color primaryGradientStart = primaryColor;
  static const Color primaryGradientEnd = primarySecondary;
  static const Color secondaryColor = accentPink;

  static ThemeData get lightTheme {
    final baseText = GoogleFonts.interTextTheme();
    final textTheme = baseText.copyWith(
      displayLarge: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: textPrimary, height: 1.2),
      displayMedium: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w700, color: textPrimary, height: 1.2),
      displaySmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary, height: 1.25),
      headlineLarge: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary, height: 1.3),
      headlineMedium: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500, color: textPrimary, height: 1.35),
      headlineSmall: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500, color: textPrimary, height: 1.35),
      titleLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
      titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: textPrimary, height: 1.45),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: textPrimary, height: 1.45),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: textSecondary, height: 1.45),
      labelLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimary),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.inter().fontFamily,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentPink,
        surface: surface,
        surfaceContainerHighest: Color(0xFFF0F0F5),
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 2,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: disabledButton,
          disabledForegroundColor: textTertiary,
          elevation: 0,
          shadowColor: shadowColor,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14, fontWeight: FontWeight.w400),
        hintStyle: GoogleFonts.inter(color: textTertiary, fontSize: 14),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
        floatingLabelStyle: GoogleFonts.inter(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      textTheme: textTheme,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      dividerTheme: const DividerThemeData(color: borderLight, thickness: 1, space: 24),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: textPrimary,
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: surface,
        indicatorColor: primaryColor.withValues(alpha: 0.12),
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.inter(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w500,
            color: states.contains(WidgetState.selected) ? primaryColor : textSecondary,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected) ? primaryColor : textSecondary,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: borderLight.withValues(alpha: 0.35),
        selectedColor: primaryColor.withValues(alpha: 0.15),
        labelStyle: GoogleFonts.inter(color: textPrimary, fontSize: 14),
        secondaryLabelStyle: GoogleFonts.inter(color: primaryColor, fontSize: 14),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide.none,
      ),
    );
  }

  static ThemeData get darkTheme {
    final darkText = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.inter().fontFamily,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFF121218),
      colorScheme: const ColorScheme.dark(
        primary: primarySecondary,
        secondary: accentPink,
        surface: Color(0xFF1C1C24),
        surfaceContainerHighest: Color(0xFF2A2A34),
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1C1C24),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1C1C24),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: darkText,
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: const Color(0xFF1C1C24),
        indicatorColor: primaryColor.withValues(alpha: 0.25),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: states.contains(WidgetState.selected) ? primarySecondary : const Color(0xFFB4B4C8),
          ),
        ),
      ),
    );
  }
}
