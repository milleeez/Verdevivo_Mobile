import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand colors from style.css
  static const Color greenDark = Color(0xFF183D2B);
  static const Color greenDark2 = Color(0xFF16301F);
  static const Color greenMedium = Color(0xFF4C7C5F);
  static const Color greenMedium2 = Color(0xFF2E5D42);
  static const Color greenLight = Color(0xFFDCEBE1);
  static const Color greenLighter = Color(0xFFEDF5EF);
  static const Color greenInk = Color(0xFF204B35);

  static const Color coral = Color(0xFFFF7A4D);
  static const Color coralDark = Color(0xFFDD5524);
  static const Color coralLight = Color(0xFFFFE9DF);
  static const Color coralInk = Color(0xFFB0421A);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAFAF7);
  static const Color cream = Color(0xFFF7F5EE);
  static const Color bg = Color(0xFFFBFAF6);
  static const Color text = Color(0xFF1D2B22);
  static const Color textMuted = Color(0xFF454F48);
  static const Color textLight = Color(0xFF5F6A63);
  static const Color border = Color(0xFFE7E4DA);
  static const Color cardBg = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF3FAE6A);
  static const Color successInk = Color(0xFF1E7A45);
  static const Color warning = Color(0xFFF0A53A);
  static const Color warningInk = Color(0xFF8F5E14);
  static const Color danger = Color(0xFFE2564A);
  static const Color dangerInk = Color(0xFFBB3B30);
  static const Color info = Color(0xFF3D8BD6);
  static const Color infoInk = Color(0xFF2664A0);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.greenMedium,
        primary: AppColors.greenDark,
        secondary: AppColors.coralDark,
        background: AppColors.bg,
        surface: AppColors.cardBg,
      ),
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.quicksand(
          color: AppColors.greenDark,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: GoogleFonts.quicksand(
          color: AppColors.greenDark,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.quicksand(
          color: AppColors.greenDark,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        titleMedium: GoogleFonts.quicksand(
          color: AppColors.greenDark,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        bodyLarge: GoogleFonts.nunito(
          color: AppColors.text,
          fontSize: 15,
        ),
        bodyMedium: GoogleFonts.nunito(
          color: AppColors.textMuted,
          fontSize: 13.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.greenDark),
        titleTextStyle: GoogleFonts.quicksand(
          color: AppColors.greenDark,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.coralDark,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.greenDark,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
    );
  }
}
