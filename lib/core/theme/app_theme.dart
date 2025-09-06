import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

class AppTheme {
  // Base colors
  static const Color primaryColor = Color(0xFF008080);
  static const Color secondaryColor = Color(0xFF4DB6AC);
  static const Color accentColor = Color(0xFFFFA000);

  static const Color errorColor = Color(0xFFD32F2F);
  static const Color darkErrorColor = Color(0xFFCF6679);

  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1C1D1F);

  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);

  static const Color onPrimaryLight = Colors.white;
  static const Color onPrimaryDark = Colors.white;

  static const Color onSecondaryLight = Colors.black;
  static const Color onSecondaryDark = Colors.black;

  static const Color onSurfaceLight = Color(0xFF333333);
  static const Color onSurfaceDark = Color(0xFFE0E0E0);

  static const Color onBackgroundLight = Color(0xFF333333);
  static const Color onBackgroundDark = Color(0xFFE0E0E0);

  static const Color onErrorLight = Colors.white;
  static const Color onErrorDark = Colors.black;

  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double inputRadius = 12.0;

  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: BorderSide(width: 1.5, color: color),
      );

  static ThemeData lightTheme = ThemeData.light().copyWith(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: onPrimaryLight,
      secondary: secondaryColor,
      onSecondary: onSecondaryLight,
      surface: surfaceLight,
      onSurface: onSurfaceLight,
      background: backgroundLight,
      onBackground: onBackgroundLight,
      error: errorColor,
      onError: onErrorLight,
    ),
    scaffoldBackgroundColor: backgroundLight,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: onSurfaceLight,
      displayColor: onSurfaceLight,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: _border(const Color(0xFFE0E0E0)),
      focusedBorder: _border(primaryColor),
      errorBorder: _border(errorColor),
      focusedErrorBorder: _border(errorColor),
      labelStyle: const TextStyle(color: Color(0xFF616161)),
      hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight,
      elevation: 1,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        color: onSurfaceLight,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: onSurfaceLight),
    ),
    cardTheme: CardTheme(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryLight,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryColor,
      unselectedItemColor: const Color(0xFF9E9E9E),
      elevation: 4,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFE0E0E0),
      selectedColor: primaryColor,
      secondarySelectedColor: primaryColor,
      labelStyle: GoogleFonts.poppins(color: Colors.black),
      secondaryLabelStyle: GoogleFonts.poppins(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: onPrimaryDark,
      secondary: secondaryColor,
      onSecondary: onSecondaryDark,
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      background: backgroundDark,
      onBackground: onBackgroundDark,
      error: darkErrorColor,
      onError: onErrorDark,
    ),
    scaffoldBackgroundColor: backgroundDark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: onSurfaceDark,
      displayColor: onSurfaceDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: _border(const Color(0xFF424242)),
      focusedBorder: _border(primaryColor),
      errorBorder: _border(darkErrorColor),
      focusedErrorBorder: _border(darkErrorColor),
      labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
      hintStyle: const TextStyle(color: Color(0xFF757575)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        color: onSurfaceDark,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryDark,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: primaryColor,
      unselectedItemColor: const Color(0xFF757575),
      elevation: 4,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF424242),
      selectedColor: primaryColor,
      secondarySelectedColor: primaryColor,
      labelStyle: GoogleFonts.poppins(color: Colors.white),
      secondaryLabelStyle: GoogleFonts.poppins(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
