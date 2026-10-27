import 'package:flutter/material.dart';

class AppColors {
  // Brand Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF7ED), // Warm light cream
      Color(0xFFF5F3FF), // Soft clinical lavender
    ],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
  );

  static const LinearGradient horizontalBrandGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFA44CFF), Color(0xFF7F7CF0), Color(0xFFCFCDF8)],
  );

  // Core Brand Colors
  static const Color primaryPurple = Color(0xFF5B14B8);
  static const Color primaryPurpleLight = Color(0xFFA44CFF);
  static const Color deepPurpleText = Color(0xFF28006D);
  static const Color purpleSurface = Color(0xFFE8DDFF);
  static const Color purpleBorder = Color(0x3328006D);

  // Teal / Cyan Accents
  static const Color cyanPill = Color(0xFF76F1FF);
  static const Color cyanText = Color(0xFF006D76);
  static const Color tealButton = Color(0xFF006971);
  static const Color lightCyan = Color(0xFF87F3FF);

  // Status & Clinical Severity
  static const Color criticalRed = Color(0xFFBA1A1A);
  static const Color criticalBg = Color(0xFFFFDAD6);
  static const Color criticalTextDark = Color(0xFF93000A);
  static const Color warningOrange = Color(0xFFF2994A);
  static const Color warningBg = Color(0xFFFFF4E5);
  static const Color successGreen = Color(0xFF10B981);
  static const Color successBg = Color(0xFFE6F9F0);

  // Neutrals & Surfaces
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF8F9FA);
  static const Color surfacePillGray = Color(0xFFEDEEEF);
  static const Color textPrimary = Color(0xFF191C1D);
  static const Color textSecondary = Color(0xFF494552);
  static const Color textMuted = Color(0xFF79747E);
  static const Color borderGray = Color(0xFFCBC4D4);
  static const Color borderSubtle = Color(0x4DCBC4D4);
}
