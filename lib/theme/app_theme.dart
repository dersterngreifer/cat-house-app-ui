import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Color Palette
  static const Color primaryColor = Color(0xFF7C5CFC); // Electric Violet
  static const Color primaryLight = Color(0xFF9B80FF);
  static const Color primaryDark = Color(0xFF5B3FD9);

  static const Color secondaryColor = Color(0xFFFF5C8D); // Hot Pink
  static const Color secondaryLight = Color(0xFFFF85AB);

  static const Color accentColor = Color(0xFF00D4FF); // Cyan
  static const Color accentLight = Color(0xFF40E4FF);

  static const Color backgroundColor = Color(0xFFF5F3FF); // Light Lavender
  static const Color surfaceColor = Color(0xFFEBE8FF);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color cardDarkColor = Color(0xFFFFFFFF);

  static const Color successColor = Color(0xFF0BBF88);
  static const Color warningColor = Color(0xFFE5A800);
  static const Color errorColor = Color(0xFFE8234A);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A3E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF1A1A3E); // Dark text for light theme
  static const Color textMuted = Color(0xFF9FA6B2);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C5CFC), Color(0xFF9B80FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFFF5C8D), Color(0xFFFF9ABB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF5F3FF), Color(0xFFEFECFF), Color(0xFFE8E4FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient homeGradient = LinearGradient(
    colors: [
      Color(0xFFF8F6FF),
      Color(0xFFF0EDFF),
      Color(0xFFE8E4FF),
      Color(0xFFE0DAFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Colors.transparent, Color(0xE6F5F3FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.3, 1.0],
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0xFF7C5CFC), Color(0xFF00D4FF), Color(0xFFFF5C8D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Spacing System
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 36.0;

  // Typography
  static const TextStyle heading1 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static const TextStyle subtitle1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.1,
    height: 1.6,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.1,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.2,
  );

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: primaryColor.withOpacity(0.15),
      blurRadius: 30,
      offset: const Offset(0, 15),
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: primaryColor.withOpacity(0.3),
      blurRadius: 40,
      offset: const Offset(0, 20),
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> glowShadow = [
    BoxShadow(
      color: primaryColor.withOpacity(0.5),
      blurRadius: 40,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> accentShadow = [
    BoxShadow(
      color: accentColor.withOpacity(0.35),
      blurRadius: 25,
      offset: const Offset(0, 10),
    ),
  ];

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 350);
  static const Duration slowAnimation = Duration(milliseconds: 600);
}
